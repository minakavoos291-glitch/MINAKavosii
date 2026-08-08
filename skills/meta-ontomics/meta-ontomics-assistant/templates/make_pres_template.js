// قالب ساخت ارائه متاآنتومیک — pptxgenjs
// تم: شب عمیق (فضا/فرکانس) + طلایی — اسلایدهای تیره/روشن متناوب (ساندویچ)
// استفاده: cd /data/workspace/meta-ontomics && node make_pres.js
// پس از ساخت: تبدیل به PDF با soffice، بررسی بصری با pdftoppm + PIL
const pptxgen = require("pptxgenjs");
const pres = new pptxgen();
pres.layout = "LAYOUT_16x9"; // 10 x 5.625

const FONT = "Tahoma"; // فونت امن برای رندر فارسی
const C = {
  bg: "0F1226", card: "1B2140", card2: "262E55",
  light: "F6F4EE", ink: "1A1F3D",
  gold: "E8B64C", violet: "8B7CF6", teal: "3ECFB2",
  white: "FFFFFF", muted: "9AA0C0", mutedD: "6A7094",
  green: "7FBF7F", red: "E06C6C",
};

// راهنمای QA:
// 1) soffice --headless --convert-to pdf file.pptx
// 2) pdftoppm -jpeg -r 100 file.pdf slide
// 3) بررسی پیکسلی (میانگین روشنایی، درصد پیکسل روشن/تیره، ناحیه متن)
// 4) pdftotext file.pdf - | grep کلمات کلیدی فارسی (تأیید رندر متن)

pres.writeFile({ fileName: "/data/workspace/meta-ontomics/OUTPUT.pptx" }).then(() => console.log("OK"));
