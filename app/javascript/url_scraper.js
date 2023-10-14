const puppeteer = require("puppeteer");

async function scrapeUrls() {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto("https://www.lacomiqueria.com.ar");

    const urls = await page.evaluate(() => {
        const links = Array.from(document.querySelectorAll("a"));
        const uniqueUrls = new Set();

        links.forEach((link) => {
            const href = link.href;
            if (
                href &&
                href.startsWith("https://www.lacomiqueria.com.ar") &&
                href.indexOf("://") !== -1
            ) {
                const cleanedUrl = href.replace("https://www.lacomiqueria.com.ar", "");
                uniqueUrls.add(cleanedUrl);
            }
        });

        return Array.from(uniqueUrls);
    });

    await browser.close();

    // Format URLs as CSV content
    const csvContent = urls.map((url) => `"${url}"`).join("\n");
    return csvContent;
}

module.exports = scrapeUrls;
