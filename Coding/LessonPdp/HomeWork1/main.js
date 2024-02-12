const data = [
  {
    car: 'BMW',
    description:
      'BMW, in full Bayerische Motoren Werke AG, German automaker noted for quality sports sedans and motorcycles and one of the most prominent brands in the world. Headquarters are in Munich.',
    price: '120.000$',
    img: './images/bmw.avif',
  },
  {
    car: 'AUDI',
    description:
      'Audi AG (Audi) a subsidiary of Volkswagen AG, is an automobile manufacturer. It designs, develops, manufactures, and commercializes premium cars, and motorcycles globally.',
    price: '140.000$',
    img: './images/audi.avif',
  },
  {
    car: 'FERRARI',
    description:
      'Ferrari has a rich racing history and is a well known premium automobile brand. The fastest street Ferrari is the F50 GT1, which can go over 370 kph (about 222 mph).The most powerful Ferrari is the FXX, which has about 800 horsepower.',
    price: '160.000$',
    img: './images/ferrari.avif',
  },
  {
    car: 'LAMBORGHINI',
    description:
      "Automobili Lamborghini S.p.A. (Italian pronunciation: [autoˈmɔːbili lamborˈɡiːni]) is an Italian manufacturer of luxury sports cars and SUVs based in Sant'Agata Bolognese. The company is owned by the Volkswagen Group through its subsidiary Audi.",
    price: '180.000$',
    img: './images/lamborghini.avif',
  },
]

let img = document.getElementById('carImg'),
  description = document.querySelector('.description'),
  cars = document.getElementById('cars'),
  price = document.querySelector('.price');

let carsName = [];
for (let i = 0; i < data.length; i++){
  const car = document.createElement('li');
  carsName.push(car);
  car.textContent = data[i].car;
  cars.appendChild(car);
  car.addEventListener('click', () => {
    setData(i);
  });
};

price.textContent = data[0].price;
description.textContent = data[0].description
carsName[0].classList.add('active');

const setData = (index) => {
  carsName.forEach(item => item.classList.remove('active'));
  carsName[index].classList.add('active');
  data.map((item, indx) => {
    if (indx == index) {
      price.textContent = item.price;
      description.textContent = item.description;
      img.src = item.img;
    }
  })
}


