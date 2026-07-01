class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.57.0.tgz"
  sha256 "4868919a9570cb5bf68ac1f7205011ff2daa23bb37f870fe6d433ba00b01cd98"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a21aec343f88a5e1601b4c3a20c675a2950fa09f0f052b97a4fb4e9c292ccfe"
    sha256 cellar: :any,                 arm64_sequoia: "d274dc71e54e791ca84f15cf0c6d6a47fb853f065616f0cb11811a34bc7eeb3d"
    sha256 cellar: :any,                 arm64_sonoma:  "d274dc71e54e791ca84f15cf0c6d6a47fb853f065616f0cb11811a34bc7eeb3d"
    sha256 cellar: :any,                 sonoma:        "01e89932d965952e4cde503f2f55f343a516b6b70265a626a163dc38e718eaf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "066f2e93902bcbbb3bc758bcf4eec567ea8b78a2027eb8e3cbbc1ff4499dd149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396d7d9d0269b7595e045daef6453e7df137bc1d33960c6141ee8a4bb41079c1"
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