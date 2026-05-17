class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.50.0.tgz"
  sha256 "2403cffed086ef37f6fedfbf1be681a953dbac4f5ba989aa4983ef6b86ef93b5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1dcdcad8da2cef3c1f13563f4d1fa8aacd87fd294287c92ecdf25f53833d7dce"
    sha256 cellar: :any,                 arm64_sequoia: "920c6de773c35392f56a8f20864f03668c90c5c5ef250014b08a9d126d9488ae"
    sha256 cellar: :any,                 arm64_sonoma:  "920c6de773c35392f56a8f20864f03668c90c5c5ef250014b08a9d126d9488ae"
    sha256 cellar: :any,                 sonoma:        "755b72200061f0ff95fd4470aabee38a01830be49e1bdcae9000a3bc26cfa347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ffc262aaac4314f7acb5f247ae0d4b95497623733f9ed561052d847ce1917f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a1b431ac3aea4c99e8e664aba622ab11f27ebc44a8b4142f2d1f6553338344"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end