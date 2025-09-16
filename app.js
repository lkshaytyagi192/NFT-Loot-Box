// Simulated data (replace with Aptos JS SDK calls later)
let lootBox = {
    price: 100000000, // in APT small units
    opened_boxes: 0,
    total_boxes: 10
};

let user = {
    boxes_opened: 0,
    nft_collection: []
};

const lootPriceEl = document.getElementById('loot-price');
const openedBoxesEl = document.getElementById('opened-boxes');
const totalBoxesEl = document.getElementById('total-boxes');
const progressBarEl = document.getElementById('progress-bar');
const openBoxBtn = document.getElementById('open-box');
const lastNftEl = document.getElementById('last-nft');
const errorEl = document.getElementById('error');
const userBoxesEl = document.getElementById('user-boxes');
const nftCollectionEl = document.getElementById('nft-collection');
const connectWalletBtn = document.getElementById('connect-wallet');

let walletConnected = false;

// Connect wallet
connectWalletBtn.addEventListener('click', () => {
    walletConnected = true;
    alert('Wallet connected!');
    openBoxBtn.disabled = false;
});

// Initialize loot box display
function updateLootBoxUI() {
    lootPriceEl.textContent = (lootBox.price / 10**8).toFixed(2);
    openedBoxesEl.textContent = lootBox.opened_boxes;
    totalBoxesEl.textContent = lootBox.total_boxes;
    progressBarEl.style.width = (lootBox.opened_boxes / lootBox.total_boxes) * 100 + '%';
    userBoxesEl.textContent = user.boxes_opened;
    nftCollectionEl.innerHTML = '';
    user.nft_collection.forEach(nft => {
        const div = document.createElement('div');
        div.className = 'nft-item';
        div.textContent = nft;
        nftCollectionEl.appendChild(div);
    });
}

updateLootBoxUI();

// Open loot box
openBoxBtn.addEventListener('click', () => {
    if (!walletConnected) {
        errorEl.textContent = 'Connect your wallet first!';
        return;
    }
    if (lootBox.opened_boxes >= lootBox.total_boxes) {
        errorEl.textContent = 'Sold out!';
        return;
    }

    errorEl.textContent = '';
    // Simulate winning NFT
    const nftId = 'NFT-' + Math.floor(Math.random() * 1000);
    lastNftEl.textContent = '🎉 You won ' + nftId;
    
    // Update data
    lootBox.opened_boxes++;
    user.boxes_opened++;
    user.nft_collection.push(nftId);

    updateLootBoxUI();
});
