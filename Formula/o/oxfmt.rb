class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.51.0.tgz"
  sha256 "944c640c2b7e9edae82a378c49c1315331bb736e84fb92a1dad76463c9b09e63"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eea9f149fa79ecb355490252fb8c6967e6249f671942bcce8d475f75b1ae7aff"
    sha256 cellar: :any,                 arm64_sequoia: "2b776c0769958707f199ef5a3db7c15a6341b4b699fd880a4698e21d285374b3"
    sha256 cellar: :any,                 arm64_sonoma:  "2b776c0769958707f199ef5a3db7c15a6341b4b699fd880a4698e21d285374b3"
    sha256 cellar: :any,                 sonoma:        "1314199e6f109eadb1ae48ed1c1e1e58752cd269067e0c7b0ab7ec29502113ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a3545d3355228fcb4d6d99a4554d23bd72c3e555e35e74d3da93635395c454d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc45e311db520c21df73d99d77269976739ec1ee699676d650340e83fb0de9f"
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