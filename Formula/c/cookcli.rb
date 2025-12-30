class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "60f3ae79fb0379ee9ec8035745c760e49efe15ef9e91f1a1618d5c89d4bc3463"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4e3f48e4d1b26545e9aa2632dcfa4be02b910d0ff71310fb24c38e1ad1550513"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bf8e80c8d977bdf4ca4552cf8bc08862e0b5141dd09b02073f0aa910fc98c6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f0e0fcf7cb771cbe528ebe0894862d3af1d91423adb537c42398bcc5c5f7ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5acffcb96346db93044758039a48a8d9d18dfedb25fabfd15337bcd61cc4ae3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704d89b348aeaa1a8f15bcd2d99fc504b5becee4cef6b7b6fe8337d30543c624"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a17f2001ebe8ca03818920d7a8b607270ff9b9508224f514a7dda30b2ceb825"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false)
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