const scrapeUrls = require('./url_scraper');

async function runScraping() {
    const urls = await scrapeUrls();
    console.log(urls);
}

runScraping();