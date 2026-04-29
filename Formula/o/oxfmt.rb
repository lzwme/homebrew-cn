class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.47.0.tgz"
  sha256 "369d3b082f1baf4eb73f99ba69e0a4a7e8a799b381bb7705327c2040d5e1d490"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32fe45d97d3cd7e566dd3199a781261602690b864d8f8cfae90d1cd54168a49d"
    sha256 cellar: :any,                 arm64_sequoia: "6348b7aa4313ee749cb7d321356e2eacf188a5fe7c161ed48234b4c80a91cd67"
    sha256 cellar: :any,                 arm64_sonoma:  "6348b7aa4313ee749cb7d321356e2eacf188a5fe7c161ed48234b4c80a91cd67"
    sha256 cellar: :any,                 sonoma:        "52b50645e919f7ba6bffc8a55b958b92de1d1c2e70ab15e837679f0edc9566c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d5d98c8cb7f20416bbb2d626a8e589474d7460540586c28d49f833d0f6a7331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24dee560abf68af4f91891bb301cdea758209639aa31528975f3fc052869b968"
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