class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "f68d3714b42f6b67ae5b6f4d047b5d724bc5a22bc3064725b45140bfcda69142"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c990c214dc6cadd16a4c452519bfd79661119a53ceb07cc84689ded6936433f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9cb1382fd0c41ffd8035d7e3aad3a98cbd6a712ffb9740b9a765d71894a47b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cf5198ccce318b0613c0671fa475458b7e283d3387fef1b2e84e6ff6b5bed76"
    sha256 cellar: :any_skip_relocation, sonoma:        "9749507214de1c9d7f36e499a532978c84a7829c57bfde03a64bf73e2516697c"
    sha256 cellar: :any,                 arm64_linux:   "cfc5c229815c1cbf664856e61eb0246735f7388f657b5692f5208ba3fb7bb440"
    sha256 cellar: :any,                 x86_64_linux:  "5f0dbd4d2c7a9d8fc0eb38a4408778cfb572e8656763dede137fc5edc7ffc203"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
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