class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "6701118fed622aa2435f4d803ebdd99df9b1e99ce25e19476b6c1bcc87b7b2be"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e25b5921b9f62f5ecbc8aa00372dd276a332ce940666eff3941d87cb73ed58ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e299079194c3c7bddbccad57ecba949b02a24e81296cb89c202a3d62b8da2632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5c04018d325b90814ed022436a6a12816e714c98a5ccd8b726f64ae4dc62bd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "19cd010812f62af2a4962da55f51c8a78c4ecf881d8b29f4bdccfd11a156be49"
    sha256 cellar: :any,                 arm64_linux:   "edd591b57a84b3abfe0030c8b5d28e4aa7c398e31b60bd4a0078bf09da97b636"
    sha256 cellar: :any,                 x86_64_linux:  "9682cd804d262ec482b917f610e559403226c674c16eef47491b36da7eaea251"
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