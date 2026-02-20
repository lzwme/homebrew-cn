class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.34.0.tgz"
  sha256 "0e2f62ff6d6e59e82446bb3609bf2825957ac1fe565482547e6a96fa536176bc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e31a237557eb496e01236d9e27b34ded50700108f0202b749f722851b5a447e2"
    sha256 cellar: :any,                 arm64_sequoia: "4fcee7f4f8dc878c3bedb54d776a0fdcf3bae1eee4d6051ca43c756f6ef5d7e0"
    sha256 cellar: :any,                 arm64_sonoma:  "4fcee7f4f8dc878c3bedb54d776a0fdcf3bae1eee4d6051ca43c756f6ef5d7e0"
    sha256 cellar: :any,                 sonoma:        "6a51887dd03887f861628fd51244cd39428c40d8ad7de8b5c1cca2299d402057"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ff84251d82d5ed9188102e99e00d06664028064f77767d570da7b4d09ccbe09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f739fbdf947a3ea8d0c713c2d05a61e79330edda47d61cfac9d096d931d778"
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