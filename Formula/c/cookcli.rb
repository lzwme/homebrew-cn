class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https:cooklang.org"
  url "https:github.comcooklangcookcliarchiverefstagsv0.10.0.tar.gz"
  sha256 "6832191a18e4e4a2d9f5e3227631b7c598d239f01f0560bc226cc3ef3948194b"
  license "MIT"
  head "https:github.comcooklangcookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01306fee0d7da8501ff32659dcdab40c5705d12d042641a666708dfebb3efe17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "952bef99a47f0fed5596abc7c6a0e842aeaec2d3d4bc10abd49eb95d0eefe943"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "266922100f1e6d6722969acc076b1580e6a5e6a66c7c7a37856529740449564d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1657416d697b0cb55e057aa31658b514814b349c106c8576c096cac9c333b81"
    sha256 cellar: :any_skip_relocation, ventura:       "792fc80ab06153e4a6291dfbe1a450c270a3b9cc6f71e2ad32b82b4c77c191c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae275d3f812b9edd4b008a48a15e8deb4d5b9f5dc789f3971b0e188f73f881fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edb7a7f5ca3d7610a1ae9fe6e6963313a146a366440c4f948ba37697cd543be9"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}cook --version")

    (testpath"pancakes.cook").write <<~COOK
      Crack the @eggs{3} into a #blender, then add the @plain flour{125%g},
      @milk{250%ml} and @sea salt{1%pinch}, and blitz until smooth.
    COOK
    (testpath"expected.md").write <<~MARKDOWN
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
    assert_match (testpath"expected.md").read,
      shell_output("#{bin}cook recipe read --format markdown pancakes.cook")
  end
end