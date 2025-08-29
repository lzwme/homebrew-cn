class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "595003a4d8a6b17447f5b890d21a6a6844becb1cd1e3b4626f552925d3fbd215"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73cdde26b9b7c9f4b29444df663e291e3d29a5add73344c40fc00aa6583d677"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3b9597f4ff379f603018adcb93360774a4290deae0a190735c8c8dfd2f128e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59c60e264a26ed511f1b7a02641b30be5009c4968cf42287fdb4cbcbb0fbbb7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e64e55875888f9e1e75777ac3396ba382ba34c2a4c7f379a5abcad69b34d5fa"
    sha256 cellar: :any_skip_relocation, ventura:       "866cb33a63dc250144a074a22a2d8d569207eefcb2592905fb64dc1e600aa038"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b56bb250c0a922441c42af3c7eaed3155d20a62f870ea071c5380f8083988530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d655b0fc99198545b710be63f26a0b500ba6a2b32672d78e8042e3d8e032358"
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