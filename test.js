const RATE = 0.08,
      PHONE = 5000,
      EXTRA = 500,
      BUDGET = 60000,
      TOTAL = 100000;
var num = prompt( "Please enter numbers that you want to buy: ");
var amount = 0;

function calculateTax(amt) {
  return amt * RATE;
}

while ( amount < TOTAL ) {
  amount += PHONE;
  if ( amount < BUDGET ) {
    amount += EXTRA;
  }
}

amount += calculateTax(amount);

console.log("your purchase: " + amount);

if ( amount > TOTAL ) {
  console.log("You don't have much money!")
}