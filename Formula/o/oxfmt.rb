class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.36.0.tgz"
  sha256 "5a75e8da758ec9c4b5eb668f3ad6dfc4f1e59b45c9a318b6b9ba3f6fcf939206"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f368f7c76163194ca49e3ccc91dedde0093a70ce7a948a6589724b80768d2c9"
    sha256 cellar: :any,                 arm64_sequoia: "7145f0d1e9c31bca859ab696af1ac1efdc840392582fe333cf506732c442b243"
    sha256 cellar: :any,                 arm64_sonoma:  "7145f0d1e9c31bca859ab696af1ac1efdc840392582fe333cf506732c442b243"
    sha256 cellar: :any,                 sonoma:        "579584d7bef51cf9f72e06899cb7774ab963919e277975dae0f04c0d2ec0897f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ec8953d11c2b1db276da698527915a0ccc2ad728d492403cc169ef55d79dcaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83fc435e899eddc8cd8db0b52b07b50cbc386dfe381081dd633617d9f185fe3b"
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