import './shopping-cart.css';

const ShoppingCart = ({ props }) => {
  console.log(props);
  return(
  <div className='shoppingCart'>
      <h2>Shopping Cart</h2>
      <div className="cart-products">
        <table>
          <thead>
            <tr className='headers'>
              <th>Item</th>
              <th>Unit Cost</th>
              <th>Total Cost</th>
              <th>Discount</th>
            </tr>
          </thead>
        </table>
      </div>
  </div>
  )
}

export default ShoppingCart