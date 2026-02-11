class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.31.0.tgz"
  sha256 "81d8295045b82eea368af117af49d35d5b8f35f786604e4fa4bc39a3c4d9c61a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45ff9b51d226239d3f9acd2d3f2f22a4da39f76e24573adc86bb8029578bd432"
    sha256 cellar: :any,                 arm64_sequoia: "0b2e3c66edc7e7c85a0bf86b9b13b0e2ac90afe3b3b7204fffc2769757d2263d"
    sha256 cellar: :any,                 arm64_sonoma:  "0b2e3c66edc7e7c85a0bf86b9b13b0e2ac90afe3b3b7204fffc2769757d2263d"
    sha256 cellar: :any,                 sonoma:        "6ce927a2aba72a6c7fff4cad0994c39aea3b9093767056a2e11d8f5bce42c976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f71ad9d9165f1c6f79ac6eb89fd6368989730b6974f491f70c049769c3f15c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b194b65ff353b8271e6a076bd787e87cad6dc1c4a8c9889ded1262aefb08ff82"
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