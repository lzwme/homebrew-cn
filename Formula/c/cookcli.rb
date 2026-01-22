class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b4f7ace0d2d294ad16c989a99937dadb403e8410106aa6f05e7164098d7fa8cc"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72008196908dbf8a2aefe19f729d0614e3b478f4261fc9f24445c54f41d305d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04c6c815091deaf84ab6d18ee2ce57c9a2a10d5c18580e356b551f5d12dba388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8abaa4dc92e7ad827a217284e439c32126a6d152cb4147fc8bae59ff96b6e4e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7066a1f78a4e0457c41a214b6f5a0fb4f5e6497a712323deef67c87254037b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa7f7f683a538270aeb0bef3a6d35be7f54d1ed5a50772e5efea9885c908d61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584d10dcdf2af20e5fdaaaa2680b78b767a3e2994bd42789905be6068d5f2542"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    # Install npm dependencies and build CSS
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build-css"

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