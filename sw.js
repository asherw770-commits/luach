/* לוח הקומה — Service Worker: מאפשר ללוח לעבוד גם בלי אינטרנט (תצוגה, תאריכים, זמנים, היום יום).
   השעון/התאריך/הזמנים/היום יום מחושבים במכשיר, וכל נתוני היום-יום נמצאים ב-hayomyom.js — הכל נשמר במטמון. */
var CACHE = "luach-v7";
var CORE = [
  "./",
  "index.html",
  "hayomyom.js",
  "manifest.webmanifest",
  "apple-touch-icon.png",
  "icon-512.png",
  "https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js",
  "https://www.gstatic.com/firebasejs/10.12.2/firebase-database-compat.js"
];
self.addEventListener("install", function(e){
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE).then(function(c){ return Promise.all(CORE.map(function(u){ return c.add(u).catch(function(){}); })); }));
});
self.addEventListener("activate", function(e){
  e.waitUntil(caches.keys().then(function(ks){ return Promise.all(ks.map(function(k){ if(k!==CACHE) return caches.delete(k); })); }).then(function(){ return self.clients.claim(); }));
});
self.addEventListener("fetch", function(e){
  var req = e.request;
  if(req.method !== "GET") return;
  var url;
  try { url = new URL(req.url); } catch(_) { return; }
  // אל תיגע בתעבורת Firebase בזמן אמת — תמיד רשת ישירה
  if(url.hostname.indexOf("firebaseio.com") >= 0) return;
  var isApp = (url.origin === location.origin);
  var isFont = (url.hostname.indexOf("fonts.googleapis.com") >= 0 || url.hostname.indexOf("fonts.gstatic.com") >= 0);
  var isFbSdk = (url.hostname === "www.gstatic.com" && url.pathname.indexOf("/firebasejs/") >= 0);
  // מדיה שהועלתה ל-Cloudinary — לשמור במטמון כדי שתוצג גם בלי אינטרנט
  var isMedia = (url.hostname.indexOf("res.cloudinary.com") >= 0);
  if(!(isApp || isFont || isFbSdk || isMedia)) return; // שאר הדברים — רשת כרגיל
  if(isApp || isMedia){
    // קבצי האפליקציה + מדיה מ-Cloudinary: רשת-תחילה (תמיד טרי כשיש אינטרנט, נפילה למטמון כשאין) — שלא ייתקע על מטמון שבור
    e.respondWith(
      fetch(req).then(function(res){
        if(res && (res.status === 200 || res.type === "opaque")){ var copy = res.clone(); caches.open(CACHE).then(function(c){ c.put(req, copy).catch(function(){}); }); }
        return res;
      }).catch(function(){
        return caches.match(req).then(function(m){ return m || (isApp ? caches.match("index.html") : m); });
      })
    );
  } else {
    // גופנים + SDK: מטמון-תחילה (כמעט לא משתנים)
    e.respondWith(
      caches.match(req).then(function(cached){
        return cached || fetch(req).then(function(res){
          if(res && (res.status === 200 || res.type === "opaque")){ var copy = res.clone(); caches.open(CACHE).then(function(c){ c.put(req, copy).catch(function(){}); }); }
          return res;
        }).catch(function(){ return cached; });
      })
    );
  }
});
