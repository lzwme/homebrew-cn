class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.61.0.tgz"
  sha256 "e48e64e9b14fa67a5197c87866136f4f0c3e155b762b67d40d0cf74c0b3867ed"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "19dabbab86e79ae6735d93e903e325966e38df8121087d32849f0ae5d0f8ca2d"
    sha256 cellar: :any,                 arm64_sequoia: "19dabbab86e79ae6735d93e903e325966e38df8121087d32849f0ae5d0f8ca2d"
    sha256 cellar: :any,                 arm64_sonoma:  "19dabbab86e79ae6735d93e903e325966e38df8121087d32849f0ae5d0f8ca2d"
    sha256 cellar: :any,                 sonoma:        "6f4db472fa6de3bddd9fcacd20059410f1591d73e98523e19c1003150965dd5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d883579ef38a40cb136d811c309eeeec38e109bc9ad3ece261bf85f51f4da366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af626aa16c915fcdfaced9e6837102d35e28553d7caeea84e7de47ce5bcc2b0"
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