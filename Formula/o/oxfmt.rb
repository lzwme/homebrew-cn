class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.43.0.tgz"
  sha256 "91a89eecaca77697114ca4de641c078c1de0b387015f47f0329af56a3c8acc66"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38660621450f6f586a5ff3c88d67c51f6d4e67621f9be341357220283b658714"
    sha256 cellar: :any,                 arm64_sequoia: "9459fc3121068db5c19de1349800d6605be18b9077f246197a8ff03368bf2a6f"
    sha256 cellar: :any,                 arm64_sonoma:  "9459fc3121068db5c19de1349800d6605be18b9077f246197a8ff03368bf2a6f"
    sha256 cellar: :any,                 sonoma:        "be65882860c13a78d12187a7cade4dfe352ba4373be26a60dbab96b10381b06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e291aca6d54de6bdeeb4ec07efb77530fc75041eb8db0c4ae3013200bbb0904c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701c455455f9be52d58d7bc1594d8456d3add48683de750e2ccee54946dd9d2b"
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