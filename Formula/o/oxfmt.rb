class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.65.0.tgz"
  sha256 "f8c6ff3957bee9d20b3bc702999f0499c447a244b2b58f1084429ca10aafc66f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "33a6f8dc0e6510db902280f13f931fba4d9642cd75a739c5b5b2f70a11f11b80"
    sha256 cellar: :any,                 arm64_sequoia: "33a6f8dc0e6510db902280f13f931fba4d9642cd75a739c5b5b2f70a11f11b80"
    sha256 cellar: :any,                 arm64_sonoma:  "33a6f8dc0e6510db902280f13f931fba4d9642cd75a739c5b5b2f70a11f11b80"
    sha256 cellar: :any,                 sonoma:        "21210c1f3cc6846a5052cfa685d056269d09530d99edd977aa4dc21dc98847f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "635696935af7b5467422f79f100994d3b47148748ca34d2c736a4a571c718994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6262a21e2cf52674be4f7099a1bc4744d3760fa7b1779815569723f32f13265e"
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