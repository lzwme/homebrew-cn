class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "c1d159c1fd39f5237a81fd5ede47643c475d76280a8776fd6947792c6fee015b"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "609da22061158723235d00bfe88f86cded1635331a49b68a37309aab3b668958"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "15abe2047e3866262dffa6d053a0a9762dc810fe0f5827f5593ffd13531f1d71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2bff790839edc563ae3eef4a75ac9a90d39a29cad054733596f905ef1a5ce58b"
    sha256 cellar: :any,                 arm64_linux:       "b46ed25b8d44291a8f0dd5ffb2559976564fb437ede03921c52963e22a839af2"
    sha256 cellar: :any,                 x86_64_linux:      "ac69efa0eb9a37edf28ff8e125a8b956faac628232fec49307cf278bbb00e301"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Build assets
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

      1. Crack the eggs into a blender, then add the plain flour, milk and sea salt, and blitz until smooth.
    MARKDOWN
    assert_match (testpath/"expected.md").read,
      shell_output("#{bin}/cook recipe read --format markdown pancakes.cook")
  end
end