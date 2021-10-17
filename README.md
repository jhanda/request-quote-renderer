# Request Quote Product Renderer

![Freelancer](doc/preview.gif
)

## Usage

In some situations, a price may not be immediately available for all products or to all customers. If there is no price 
available for a product (price is equal to 0), the price and Add to Cart button will be replaced with a *Request a 
Quote* button.  The button will direct you to a /request-a-quote page where you can present a form to capture relevant 
details.  

The caption on the button and the URL can be updated to support other use-cases such as *Request a Sample* or *Submit a 
Bid*.  Configuration can be found under System Settings > Other > Request Quote Renderer  

## Requirements

- Liferay Commerce 3.0.0

## Installation

- Download the `.jar` file in [releases](https://github.com/jhanda/request-quote-renderer/releases/tag/1.0.0) and 
deploy it into Liferay.

or

- Clone this repository, add it to a Liferay workspace and deploy it into Liferay.

## License

[MIT](LICENSE)
