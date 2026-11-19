ZENVIXO — GITHUB + VERCEL STARTER PACKAGE
=========================================

এই ZIP-এ সর্বশেষ দেওয়া index.html ও admin.html এবং Vercel/Supabase-এর প্রাথমিক সেটআপ ফাইল রাখা হয়েছে।

ফোল্ডার:
- public/index.html       মূল ওয়েবসাইট
- public/admin.html      Admin Panel-এর বর্তমান HTML
- vercel.json            Vercel routing
- package.json           project build config
- .env.example           Supabase environment variable-এর নমুনা
- supabase/schema.sql    Supabase-এর প্রাথমিক database schema

GitHub-এ আপলোড:
1. ZIP Extract করুন।
2. Extract করা Zenvixo-GitHub-Vercel-Supabase ফোল্ডারের ভেতরের সব ফাইল/ফোল্ডার GitHub repository-র root-এ upload করুন।
   অর্থাৎ GitHub-এ public, supabase, vercel.json, package.json ইত্যাদি সরাসরি দেখা যাবে।
3. Vercel-এ Add New → Project → Import Git Repository নির্বাচন করুন।
4. Framework Preset: Other; Build Command ফাঁকা/None; Output Directory: public দিন।
5. Deploy করুন।

গুরুত্বপূর্ণ সীমাবদ্ধতা:
এই ZIP হলো Vercel-এ HTML সাইট প্রকাশের starter, সম্পূর্ণ backend-integrated production release নয়।
বর্তমান HTML-এর কিছু কাজ localStorage ব্যবহার করে। index.html-এ api/payment-methods.php এবং admin.html-এ api/admin-login.php ও api/admin-logout.php endpoint call আছে। Vercel PHP চালায় না, তাই এই PHP endpoint-নির্ভর কাজগুলো Vercel-এ চলবে না।
Supabase schema.sql শুধু database-এর টেবিল ও security policies তৈরি করে; বর্তমান HTML-কে নিজে থেকে Supabase-এ সংযুক্ত করে না। ফলে শুধু এই ZIP deploy করলে সব ব্যবহারকারীর ডেটা এক database-এ save/sync হবে—এমন নিশ্চয়তা নেই।

Supabase setup:
1. Supabase project তৈরি করুন।
2. SQL Editor-এ supabase/schema.sql রান করুন।
3. Project URL ও anon/public key Vercel Environment Variables-এ যোগ করতে হবে (নাম .env.example-এ আছে)।
4. মনে রাখবেন: এই HTML এখনো Supabase client integration সম্পন্ন করেনি। তাই শুধু key যোগ করলেই localStorage বা PHP call স্বয়ংক্রিয়ভাবে বদলাবে না।

নিরাপত্তা:
- Supabase service_role key কখনো GitHub বা browser-side HTML-এ দেবেন না।
- Admin login-কে production-এ নিরাপদ করতে Supabase Auth ও server-side authorization যুক্ত করা প্রয়োজন।
- Face verification এই প্যাকেজে বাস্তব biometric verification নয়।
