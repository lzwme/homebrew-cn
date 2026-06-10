class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "abcbeb7b35c45f39a68d2b75adc230161556c27c37b0864e947c47ceedfae9d5"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dbd1089bd3f7cd04a45ec15d8adf76900e15344e125a72075f71f6d2ad7bbbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a9dbac4a696ba4f32bfa6142912281fd5d6bd3c5286d7ef2ff243fb97f1b305"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1afcf00cd7c6f12a0c808c79d4387a7e6de120ee6ef4b6a118a21caa0d88858"
    sha256 cellar: :any_skip_relocation, sonoma:        "668fa61413945fda0b1d2a3d691f44cfefa724f302663854fbe6511a00ac3e79"
    sha256 cellar: :any,                 arm64_linux:   "71de6f3e74df518834b14dda2d07ddcc20552bd507346bac038cecbf4cbe659f"
    sha256 cellar: :any,                 x86_64_linux:  "59f364f3be1c52ab41b7fff5183a149c867b43a506e801531a0ccf7b3f023f28"
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