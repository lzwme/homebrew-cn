class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.27.2.tar.gz"
  sha256 "04f317fc85d7321d5decd6819461d699befd36bdfe8287f7c2ef5d64656a9178"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07272978b1f6d4bee45dd48bce0ce327be607b58563b37e258b9da01348a876c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f55b31aea2e2aa9896be07f6df2c8221c107703b02daa1b4ff120e031f843b95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab34f9e611fc99a98fc7773688cbd104db3897140e3c67788e76ea09ef3f6b56"
    sha256 cellar: :any_skip_relocation, sonoma:        "b644b4456e5f2d4396586e909a6639bb24faa48d1a2205520d10f03722d478a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "060a04f5ccd56840eb052a7996cb4e27134e07633a3e21867620185cd8de1fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9de05ae6b6965a66d93a9a6e76caac07a3400614450ed625ad28acf767a40ae7"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build assets
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"
    system "npm", "run", "build-js"

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