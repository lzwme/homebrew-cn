class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "00ee36f1ece86890ff2698b1a9d2a736f3500466879f57a073b62beed31379b5"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5e65defee67a0ee63c160258efe4be11de3c6dc2579bb36ffd643d9d6e7f601"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2576854282b401de53af4dfe376bcaf4158b84321832f35533239613644b289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e22dc200115d03c6c740ddc0999af5c922769359ffde20ec8644554880fe3c3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "21e375ff5ce0543f5c2ff4f2cd6bf692e662283143502b660212206c1ef7cf31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcbc736f43c625cecad757dc08a210a2c7b5a5e09aa5d4fcd4ef45a1b33152c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8798ae9374d87462d6265a08220617ce4b9b5cdfc7975a72d3da97b65e152e0"
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