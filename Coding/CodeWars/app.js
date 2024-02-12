// first Kata
// MISSING VOWEL
// const vowels = ['a', 'e', 'i', 'o', 'u'];
// const missingVowel = (s) => {
//   for (let i = 0; i < vowels.length; i++){
//     if (!s.toLowerCase().includes(vowels[i])) {
//       return i;,
//     }
//   }
// }

// console.log(missingVowel('Bb Smith sent us six neatly arranged range bicycles'));

// second Kata
// GET MIDDLE
// const getMiddle = (s) => {
//   let length = s.length;
//   if (length % 2 == 0) {
//     return s.slice(length/2 - 1, length/2 + 1);
//   } else if (length % 2 == 1) {
//     return s[Math.floor(length / 2)];
//   }
// }
// console.log(getMiddle('test'));


// third Kata
// HighAndLow
// const highAndLow = numbers => {
//   const arr = numbers.split(' ');
//   let max = Math.max(...arr);
//   let min = Math.min(...arr);
//   return `max:${max} min:${min}`;
// }
// console.log(highAndLow('1 2 -3 4 5'));

// 4-)kata
//Jayden Smit

// function JaydenSmitLetter(str) {
//   const arr = str.split(' ');
//   const newarr = arr.map(item => {
//     return item[0].toUpperCase() + item.substring(1,item.length)
//   })
//   return str = newarr.join(' ')
// }
// console.log(JaydenSmitLetter("How can mirrors be real if our eyes aren't real"))

// 5-) kata
// Missing Vowel
