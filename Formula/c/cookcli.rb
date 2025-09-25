class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "3f6c12dc3cf64f9c148995922657ca264440af750b7e15743bfb617762b077da"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d23785c6f252a69d00b9d33b4007820a28c91c26c129ad28befa85406b6f574c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1431dadf6b3e10c1ba4c480d8b67df88459640e2cba2374793eb5b270a27a97e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9ddfe8ad11295f2b31f6b254fab48a5d845005251f4d779177c49d7c5500e04"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f64a0caeb39fd0eba3ef7deaa93de748e6c29e3149e3547b87df0a01d79a006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e08c8b0b18f9981c20e21bd98754746a749b0d7a0567b4143bff5d87f7ea9101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56b4bff21e9d4f83e7eb401af443d26da5e7250c38e8710debb765fae88e91f"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false), "--ignore-scripts"
    system "npm", "run", "build-css"

    # Build and install the binary
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cook --version")

    (testpath/"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath/"expected.md").write <<~MARKDOWN
      ## Ingredients

      - *3* eggs
      - *125 g* plain flour
      - *250 ml* milk
      - *1 pinch* sea salt

      ## Cookware

      - blender

      ## Steps

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt,
      and blitz until smooth.
    MARKDOWN
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end