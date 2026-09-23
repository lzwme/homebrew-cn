class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.70.0.tgz"
  sha256 "cb6b759f6333166533bb7c383f829a8579e7f0e2fb21ff36e6e44d019c8c38b4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9a9bb61a471c2a8127cb89263a03caca191bc3577ca8483c3217346ae6aff563"
    sha256 cellar: :any,                 arm64_tahoe:       "9a9bb61a471c2a8127cb89263a03caca191bc3577ca8483c3217346ae6aff563"
    sha256 cellar: :any,                 arm64_sequoia:     "9a9bb61a471c2a8127cb89263a03caca191bc3577ca8483c3217346ae6aff563"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5b28b9966d3dab1f72bc7355f5b5ae4ff515f7be41293f15593b53f4007db07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "37c6f52909675cbff260b8d2616bfb140ecdf0f028494275d639f3a263462a16"
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