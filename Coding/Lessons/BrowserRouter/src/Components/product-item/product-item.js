import './product-item.css'
const ProductItem = ({ product }) => {
  console.log(product);
  return (
    <div className='product'>
      <img src={product.src} alt='productImage' />
      <p className="productName">{product.name}</p>
      <p className='cost'>{product.cost}£</p>
      <button className='add-btn btn btn-success'>Add to cart</button>
    </div>
  )
}

export default ProductItem