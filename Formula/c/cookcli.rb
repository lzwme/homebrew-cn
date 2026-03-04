class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "e632e67690516256f0f5b6d643a8018b4fb48fd5d5aaf79ede4826ca33008c99"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84b8f7cbb9cf510e063a83b78125b52c6d84941e6cd08054d33aa61885045616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a857e92581889921daa3fe3d738e0d1d5ce3e12d71506bcb1f981c7e90f46b6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2369ca4b47f5a8c79649d473c5da55bcce891d56c66ddfb087cb0b9386d1657"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4b2f8bfe965b864dec4bf83bc5fa0c9aaf9eef7a0b3380b1485ca81f7fc2b8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b242ab564cb4be92443eca0c66e1d100b974b3f5c84ba692c7a4bb8585dfb95f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dc146220f97ceb813d00cb4097a963df28df6f3532968a3cf1e10962f074b99"
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