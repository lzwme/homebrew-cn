class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.38.0.tgz"
  sha256 "ada4fbcbe251543a35d585d3aacb4aac1b163226e5ef8423ae1535da1f114702"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11ec78d92d1ef0b2b2527585c5ddd7da53c7f0d2da91d9eee4946744f9b29907"
    sha256 cellar: :any,                 arm64_sequoia: "5265baaee44e381290ce8384c5b897afcc3d3b500a397cf25831654103ba17ed"
    sha256 cellar: :any,                 arm64_sonoma:  "5265baaee44e381290ce8384c5b897afcc3d3b500a397cf25831654103ba17ed"
    sha256 cellar: :any,                 sonoma:        "b464f7e98669bc87ab41d7c6378fedbb59f6db1a1f88b5e339122fb51e9b4ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29a82dbdcc225ab8a134c91b64f13feac8562b21eff1eb763a810fc708e5e66a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c91058c02be5190dfafb5f458c25b5514c863d3d1cc5fcfee850ae9cd3e7f0e"
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