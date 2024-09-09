class VerifyLocationTransaction extends BaseTransaction {
    static get TYPE() {
      return 22;
    }
  
    static get FEE() {
      return `${1000000}`;
    }
  
    validateAsset() {
      const errors = [];
      if (typeof this.asset.latitude !== 'number' || typeof this.asset.longitude !== 'number') {
        errors.push(new Error('Invalid GPS coordinates'));
      }
      return errors;
    }
  
    applyAsset(store) {
      const verifier = store.account.get(this.senderId); // Verifier (seller or buyer)
      const deliveryPerson = store.account.get(this.asset.deliveryPersonId); // Delivery person's account
  
      const verifierCoords = { latitude: verifier.latitude, longitude: verifier.longitude };
      const deliveryCoords = { latitude: deliveryPerson.locationClaim.latitude, longitude: deliveryPerson.locationClaim.longitude };
  
      const distance = haversine(verifierCoords.latitude, verifierCoords.longitude, deliveryCoords.latitude, deliveryCoords.longitude);
  
      if (distance <= 5) {
        // Emit event that claim is verified
        store.event.emit('locationVerified', { deliveryPersonId: this.asset.deliveryPersonId, verifiedBy: verifier.address });
  
        // Optionally trigger payment release
        triggerPayment(store, deliveryPerson, verifier);
      }
  
      return [];
    }
  
    undoAsset(store) {
      // Logic to undo the verification if necessary
    }
  }
  
  function triggerPayment(store, deliveryPerson, verifier) {
    // Todo Add payment logic
    
    
  }
  