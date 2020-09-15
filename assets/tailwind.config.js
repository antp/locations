const defaultTheme = require('tailwindcss/defaultTheme')


module.exports = {
  purge: [],
  theme: {
    extend: {
      zIndex: {
        '0': 0,
        '10': 10,
        '20': 20,
        '30': 30,
        '40': 40,
        '50': 50,
        'sky': 10000,
      },
    },
  },
  variants: {},
  plugins: [
    require('@tailwindcss/custom-forms')
  ],
  future: {
    removeDeprecatedGapUtilities: true,
  },
}
