class Cookcli < Formula
  desc "CLI-tool for cooking recipes formated using Cooklang"
  homepage "https://cooklang.org"
  url "https://ghfast.top/https://github.com/cooklang/cookcli/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "df801ffc6e3d77417f68b305d01619886657f7c0241786a487b62a4c986a7a1b"
  license "MIT"
  head "https://github.com/cooklang/cookcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "503bb6831519448244152f9a20b542c9c58c48196414ee0b8a215fb4d4d1202e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf9cc43a0b80e1047e174216455fe458e63508c090b406c65ab8cca3dd4aba0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0637ef6b9aeb6494e0e547db5a573a241f58bcb0b44de109937eb62d3413e65b"
    sha256 cellar: :any_skip_relocation, sonoma:        "407d1c7b909103f0bc66a3e0cdb3459729d67ed1be29de95d03a28d0fd1de532"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40690eed710c27a0febe323c00ef4e8747437e01868b7ca6ac8f40850ac36fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15865b963f49bbb056c5a49af0bc43b08bd5d0147ffdcb301edb98f7ed40c2e6"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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