class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "413aaea997cdc6afe5ff122d5673733aea2ff6314173342235b4e7120ea1c276"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc029bc5636075cc7201a71077ac7eac6e927bb7955144f9e779f2a5ba8b28b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3928b150a8481c74c815a7a0cb40b8a5768e8f8a73841f87ea9a65ec75afda15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b33b7945e389e65d7293cb061c7930c4f0759dced0015eae4666e38811392a1d"
    sha256 cellar: :any,                 arm64_linux:   "bb718704e432ca83383b2a08ca4d6dc95a3c9a1c888b562f5c8479b3fa2f70f3"
    sha256 cellar: :any,                 x86_64_linux:  "376439b3a8d3f772c634d23513ba31bd86b74dd98f436a2a58cd90e43e003d74"
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