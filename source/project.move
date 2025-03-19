module MyModule::WarrantySystem {

    use aptos_framework::signer;
    use std::string::String;

    /// Struct representing a product warranty.
    struct Warranty has store, key {
        product_id: String,       // Unique identifier for the product
        owner: address,           // Address of the product owner
        expiry_date: u64,         // Expiry date of the warranty (timestamp)
    }

    /// Function to register a new product warranty.
    public fun register_warranty(owner: &signer, product_id: String, expiry_date: u64) {
        let warranty = Warranty {
            product_id,
            owner: signer::address_of(owner),
            expiry_date,
        };
        move_to(owner, warranty);
    }

    /// Function to check if a warranty is still valid.
    public fun is_warranty_valid(product_owner: address, product_id: String, current_time: u64): bool acquires Warranty {
        let warranty = borrow_global<Warranty>(product_owner);
        assert!(warranty.product_id == product_id, 1); // Ensure the product ID matches
        current_time <= warranty.expiry_date // Return true if the warranty is still valid
    }
}
