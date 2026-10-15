class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.73.0.tgz"
  sha256 "2f948dcf03bc630138124e46b8135e0e22c4bfd4f15f99ba98a87c8ca01312b6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d72e639af7a50e898e0c690ef97ab5561351c3d48f4fe1948483f11118cb01ea"
    sha256 cellar: :any,                 arm64_tahoe:       "d72e639af7a50e898e0c690ef97ab5561351c3d48f4fe1948483f11118cb01ea"
    sha256 cellar: :any,                 arm64_sequoia:     "d72e639af7a50e898e0c690ef97ab5561351c3d48f4fe1948483f11118cb01ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa233078e900402f83d4ffaf23d1fac9875cb1d94c7cc4c90a5ba8177dca8ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "53e4cd1392bbb40cb5e4f5ba4ce3782aba245523f0190a2be2c36c3886ccc911"
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