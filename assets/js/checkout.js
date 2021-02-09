const stripe = Stripe('pk_test_51IBHitCNjnBMsnzg7iz0r6uhkYs2SDj3cyw0wRs3miYWW5DrRORxJnZtC2L8myDxQjI5Gvk3QUkKS4eSo2ttrZAx002eMycirh');
const enterpriseBasicPriceId = 'price_1IEw9QCNjnBMsnzgKbjfAEUL';
const enterpriseAdvancedPriceId = 'price_1IIyEVCNjnBMsnzgVOrQKOg9';

function redirectToCheckout(priceId, successUrl, cancelUrl, errorUrl) {
    stripe.redirectToCheckout({
        lineItems: [{
          price: priceId,
          quantity: 1,
        }],
        mode: 'payment',
        successUrl: successUrl,
        cancelUrl: cancelUrl,
      }).then(function (result) {
        window.location.replace(errorUrl);
      });      
}