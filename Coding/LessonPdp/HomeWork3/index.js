const cards = Array.from(document.querySelectorAll('.card'));

const onHadleActive = (element) => {
  cards.forEach(card => card.classList.remove('active'));
  element.classList.add('active');
}

cards.forEach(card => {
  card.addEventListener('click', () => onHadleActive(card));
});