class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "113e44c38de08f62d1e888e05795893c3813601d3334d15cc0ff096f9551561a"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28ce1ee7fa21a056e1439106ea2da0debd9211169228ff4a4f68a7eecec405ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37e39686016ecbfa33f6a1ef95a0e4ce186bb9612cb2e78863c3191ceabe4441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c632af5ca3a16a24c991cd4fadeb36c6c6cacf1c9bc26a3882c53394d409cf7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9487d6b04d57beceb8d06cfce278a5dc9dd38750cf3bc4b7680ff2f5ea07b34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48cea9fbd0be5fcca43aba8ae887e3fa7bc79690813d29554c3b24f4af24a2de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "797ed4f181da7e74b2a727a0cb79ad68f9a38476df7e0fedf6996825e19ece5e"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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