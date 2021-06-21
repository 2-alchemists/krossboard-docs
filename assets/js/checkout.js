const stripe = Stripe('pk_live_51IBHitCNjnBMsnzgRCsfiK4wgd8JwZGLqMnPxVAbh880ruHGRziyCyZ4AS7NoInVSXLPNBZBju3hibq7OMcrA2lg00kP6Y6qi7');
const enterpriseBasicPriceId = 'price_1J3JztCNjnBMsnzgHyUQwSRT';

function redirectToCheckout(priceId, successUrl, cancelUrl, errorUrl) {
    stripe.redirectToCheckout({
        lineItems: [{
          price: priceId,
          quantity: 1,
        }],
        mode: 'subscription',
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      }).then(function (result) {
        window.location.replace(errorUrl);
      });      
}