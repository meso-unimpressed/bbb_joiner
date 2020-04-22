const IS_DEVELOPMENT = process.env.NODE_ENV === 'development';
const purgecss = require('@fullhuman/postcss-purgecss')({
	content: ['./src/templates/*.ecr'],
	defaultExtractor: content => content.match(/[\w-\/:]+(?<!:)/g) || [],
})

module.exports = {
	plugins: [
		require('tailwindcss'),
		require('autoprefixer'),
		...IS_DEVELOPMENT ? [] : [purgecss],
	]
};
