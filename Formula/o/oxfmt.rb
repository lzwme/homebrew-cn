class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.37.0.tgz"
  sha256 "4de2dcf1ad06c8056c884c0a627e5eb0e6e14783f0b52f5a1f38e277a084d283"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6836232d952a7e72e3e8aa9c4d8499532a12c7277e715e4b742a12971197016c"
    sha256 cellar: :any,                 arm64_sequoia: "04eb84dfbd7f6f44aa5318f3e257bc36c092a61b7822e2ce12800ca2819c512d"
    sha256 cellar: :any,                 arm64_sonoma:  "04eb84dfbd7f6f44aa5318f3e257bc36c092a61b7822e2ce12800ca2819c512d"
    sha256 cellar: :any,                 sonoma:        "632a065c3191c6e832e76ae5532d33fcee3524cee708b2c60a01d85948348831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81b20ecf340cb983b7250eef16e0d021a5a22f6911bbcae0f88328a279b85e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f76385f6f561347e3d8b9165dc6ae6216d1890a34734e307e74dab3ff7c7a2b1"
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