class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.28.0.tgz"
  sha256 "556c1cc9ebb1233556681a0f98653f691ce1b1de04690a4b5b45ce85a052390c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "771ada2673336bf53457493fc7118e0fb92ff3d670349b9ebb0f8ecea310bb65"
    sha256 cellar: :any,                 arm64_sequoia: "7801cc19364fbcb5ec8dd63335cd0c03faae7dea82721c64d479fb61d291a553"
    sha256 cellar: :any,                 arm64_sonoma:  "7801cc19364fbcb5ec8dd63335cd0c03faae7dea82721c64d479fb61d291a553"
    sha256 cellar: :any,                 sonoma:        "3d4653c85cbb0e68c7d5c549c53dcbe400938ac849c08693649564ce40eb1840"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c17c6ee36a45b7e41e03f39e2d3ed248caee00dea3c90c2a4bf4d612f4b219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2d12cefb53338c22fdd31e2a2454242882777c064f660afde2ca9b04180661"
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