class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "b5dc08200e6eb8734448d662f6139636cb79ec02820142d32baf6fcc15fb80d4"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3543077bd30433950f1199e8397b6dc214de9cf942cb024ddf0ea02c45bfb7bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e34f0c61743a9feb7fb45a035c4322cce176b7e35200734f52d999683b10b9ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d7bfd8f3b2d6c90e05c7e53a1b0c7c763306d26aaaa2a63ce6bc2bd28c66e03"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc945ff3128bc57a21e1c0e0c9f41590c1694f29f616e52ca3b0b06127ee0524"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52466524cb4b6dabb0752d52bcf1e53261c955b1d40a5aa9be50c4ad319cdef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e124272fc06acb8189fe4e4506e7ed0a4ade1260a1329d5b767688ef82ad97f"
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