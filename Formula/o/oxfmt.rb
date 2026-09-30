class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.71.0.tgz"
  sha256 "a3e06c3f9895f63476301d10c2f4eb950b3303e569af2b31760829438354f546"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ba07560a7d35900db673cbd84066fe596cb82fc0d0e16f244d77db9ed03dcd84"
    sha256 cellar: :any,                 arm64_tahoe:       "ba07560a7d35900db673cbd84066fe596cb82fc0d0e16f244d77db9ed03dcd84"
    sha256 cellar: :any,                 arm64_sequoia:     "ba07560a7d35900db673cbd84066fe596cb82fc0d0e16f244d77db9ed03dcd84"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "228929194ef890f7b351def791de2dc495cc223189c43980214de0cbbaf227a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e624bb7140a48ea4ee6e568596461e07564647f3af0104fbbe077bd9f6571447"
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