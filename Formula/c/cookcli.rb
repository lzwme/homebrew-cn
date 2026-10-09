class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "5353ec5b58b679bf529ec7e2d9d55d9bb4daf4f061c34246049f336de145e5ab"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d980ae5aaec5a43d5d6083c583d015d8a97ac643c62fc7bae7dd3aa59f531107"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "405ebbb126194f9ce5d1f2e7a0eba0e2019fc4bb52d730900af291d1a37a8e68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a7f30a72deb7a02f170ba9ab4b6c89aec6784186dd8672c28e3e6f86c71d7e1"
    sha256 cellar: :any,                 arm64_linux:       "66fa0d569aded364720a0704ab306c0c6fb72c7104892a9a60388db22afdc60d"
    sha256 cellar: :any,                 x86_64_linux:      "377b0a39e1e34d6cae8740d5a8910a72984f899d38dd853ceb0bf874ef6edc2b"
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