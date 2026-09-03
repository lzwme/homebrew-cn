class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.66.0.tgz"
  sha256 "f42e9c2d895c7b3c383c9fb1a510840436d334e69c5b4e9ec669fc92a0770f52"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5337548f0b3de444fec60c0b527c7a5e9716ff5890831d2a78b0d616c9e05f39"
    sha256 cellar: :any,                 arm64_sequoia: "5337548f0b3de444fec60c0b527c7a5e9716ff5890831d2a78b0d616c9e05f39"
    sha256 cellar: :any,                 arm64_sonoma:  "5337548f0b3de444fec60c0b527c7a5e9716ff5890831d2a78b0d616c9e05f39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df89bb5553585e1be16a4cc40fad52ea8796eb49a99a7888c34e959cffd1e416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51c1f8ceb0822830ff202bfa5010557a5282440011d880c5681b0ada8f914e75"
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