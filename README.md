# openwashdata Conference 2025 Website

This repository contains the source code for the openwashdata Conference 2025 website.

## Conference Details

- **Dates:** July 15-17, 2025
- **Location:** ETH Zurich, Switzerland
- **Website:** https://openwashdata-conf.github.io/2025/

## Development

This website is built with [Quarto](https://quarto.org/).

### Prerequisites

- [Quarto](https://quarto.org/docs/get-started/) installed
- Text editor (VS Code, RStudio, etc.)

### Local Development

1. Clone this repository
2. Navigate to the project directory
3. Run `quarto preview` to start a local server
4. Make changes and see them live

### Building the Site

```bash
quarto render
```

This will generate the static site in the `docs/` directory.

## Structure

- `index.qmd` - Homepage
- `prerequisites/` - Day 2 hackathon preparation guide
- `day1/` - Day 1 session pages
- `day2/` - Day 2 hackathon pages
- `day3/` - Day 3 social day information
- `_quarto.yml` - Site configuration
- `styles.css` - Custom styling

## Contributing

Please submit pull requests for any improvements or corrections.

## License

This website is licensed under the MIT License.