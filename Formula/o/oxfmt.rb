class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.67.0.tgz"
  sha256 "70d9fd9edf644a23f513a673e73a8ebe6e828e13adfaa1fc78b86fe13382ef1d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "339ed6d9378ca3f991290338bb5668a739c3d2578ba4d4ddd5910c8d4351620c"
    sha256 cellar: :any,                 arm64_tahoe:       "339ed6d9378ca3f991290338bb5668a739c3d2578ba4d4ddd5910c8d4351620c"
    sha256 cellar: :any,                 arm64_sequoia:     "339ed6d9378ca3f991290338bb5668a739c3d2578ba4d4ddd5910c8d4351620c"
    sha256 cellar: :any,                 arm64_sonoma:      "339ed6d9378ca3f991290338bb5668a739c3d2578ba4d4ddd5910c8d4351620c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c92ee6b92f31f36dd7f1071bd3560c5524a93e6b878fb47e62372755a9243b33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d6f65a28c390e46cc96c308620aa9b907fb419e66b323adf2b353f9ecac249b2"
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