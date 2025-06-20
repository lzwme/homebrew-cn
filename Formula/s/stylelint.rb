class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-16.21.0.tgz"
  sha256 "bdfba071e2d7caa2c9fdb2229a584b660f2a00b815a00e81f6837e4e05d069bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db5c39e665504b325ec57d3bfa5f24c6c5660a7eb1fb97c18caff4d39ddf2a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db5c39e665504b325ec57d3bfa5f24c6c5660a7eb1fb97c18caff4d39ddf2a4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db5c39e665504b325ec57d3bfa5f24c6c5660a7eb1fb97c18caff4d39ddf2a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f6a47bec1047671cf8c156b041207a08aa365705909c96cdd917f4b908d26cd"
    sha256 cellar: :any_skip_relocation, ventura:       "5f6a47bec1047671cf8c156b041207a08aa365705909c96cdd917f4b908d26cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db5c39e665504b325ec57d3bfa5f24c6c5660a7eb1fb97c18caff4d39ddf2a4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5c39e665504b325ec57d3bfa5f24c6c5660a7eb1fb97c18caff4d39ddf2a4f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~JSON
      {
        "rules": {
          "block-no-empty": true
        }
      }
    JSON

    (testpath/"test.css").write <<~CSS
      a {
      }
    CSS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end