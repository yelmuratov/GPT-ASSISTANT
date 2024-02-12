import './products.css'
import ProductItem from '../product-item/product-item'

const Products = ({ products }) => {
  return (
    <div className='wrapper'>
      <h2>Products</h2>
      <div className='products'>
        {products.map((product) => (
          <ProductItem product={product} key={product.id} />
        ))}
      </div>
    </div>
  )
}

export default Products