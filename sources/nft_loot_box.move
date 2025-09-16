module MyModule::NFTLootBox {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;
    use aptos_framework::timestamp;
    use std::vector;

    /// Struct representing an NFT loot box
    struct LootBox has store, key {
        price: u64,           // Price to open the loot box in APT
        total_boxes: u64,     // Total loot boxes available
        opened_boxes: u64,    // Number of boxes already opened
        nft_rewards: vector<u64>, // Available NFT IDs that can be won
    }

    /// Struct to track user's opened boxes and rewards
    struct UserRewards has store, key {
        boxes_opened: u64,
        nft_collection: vector<u64>,
    }

    /// Function to create a new loot box system
    public fun create_loot_box(
        owner: &signer, 
        price: u64, 
        total_boxes: u64,
        nft_rewards: vector<u64>
    ) {
        let loot_box = LootBox {
            price,
            total_boxes,
            opened_boxes: 0,
            nft_rewards,
        };
        move_to(owner, loot_box);
    }

    /// Function for users to open a loot box and receive a random NFT
    public fun open_loot_box(
        user: &signer, 
        loot_box_owner: address
    ) acquires LootBox, UserRewards {
        let user_addr = signer::address_of(user);
        let loot_box = borrow_global_mut<LootBox>(loot_box_owner);
        
        // Check if boxes are still available
        assert!(loot_box.opened_boxes < loot_box.total_boxes, 1);
        
        // Transfer payment from user to loot box owner
        let payment = coin::withdraw<AptosCoin>(user, loot_box.price);
        coin::deposit<AptosCoin>(loot_box_owner, payment);
        
        // Generate pseudo-random NFT reward using timestamp
        let random_seed = timestamp::now_microseconds() % vector::length(&loot_box.nft_rewards);
        let won_nft = *vector::borrow(&loot_box.nft_rewards, random_seed);
        
        // Update loot box state
        loot_box.opened_boxes = loot_box.opened_boxes + 1;
        
        // Initialize or update user rewards
        if (!exists<UserRewards>(user_addr)) {
            let user_rewards = UserRewards {
                boxes_opened: 1,
                nft_collection: vector::singleton(won_nft),
            };
            move_to(user, user_rewards);
        } else {
            let user_rewards = borrow_global_mut<UserRewards>(user_addr);
            user_rewards.boxes_opened = user_rewards.boxes_opened + 1;
            vector::push_back(&mut user_rewards.nft_collection, won_nft);
        };
    }
}