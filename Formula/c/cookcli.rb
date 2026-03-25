class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "81dcfd9a6b7509790ac0c60944ed86f7d419d94587b8e4d496c3c7d5d374bd8b"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc26069144dfb69e88c8402e66bf7154b4c8feb2a2d77dcc123dc15fdb335bb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d7529f3a431f0b97920ead89e2946199e7c19ae7c62aecebf768343b34c3b8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c181db2d3ed6b3402507ae559ad1aa7198ae06ebd286a28b732c06751fe72ebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1bd23585e81a122f58fb2941a51095904bbbfe54bb950aa6f5850aff786960b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aae8b16609e0e01e94dc32203fabaa0147e705133f1ba4550775d6f7aae877f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1113dcc61092aa3951982afe4a693af7b4e4f5dcc3f0d0474eec4d163f66f15"
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