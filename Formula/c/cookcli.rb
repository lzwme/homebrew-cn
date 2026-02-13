class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "b759ac7e27fde242c1cfaefdbffa9258f4b1e42fd4101bf7d4c5d1fb1be3db8a"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d22a71074b4bad682564aa3720458b37467fd1bd3ab8aa66e4a47ec84195112e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a6bb30e53e1766b1a1cd394b5653e1bdb9eec7e8c8ba1e66cd3051b8e0b41d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d2b469ecc9df103bf065053fb15627a3916cf21a0551d16f879def5b1194d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "84f9a2ad12329e1e23caaa31d121e752b3252c831fc21e32010e3e01b44d5363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b9c2ca8195263c2c9ce79581adde3e0f75214dd90c7c3134d3a3573c4623357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34181ee9a0509d48f970974d81f1a6f008b34d7a30269d306d2e12643ce4a30c"
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