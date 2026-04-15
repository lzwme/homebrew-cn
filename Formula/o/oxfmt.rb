class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.45.0.tgz"
  sha256 "79eb835450c844dafd302623431def837812f40494e602288ad650ef1387c739"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bb901f2a2d20429ac48b8c1f248f0558d792e4c431433e217f0db09b53d74e6c"
    sha256 cellar: :any,                 arm64_sequoia: "e805719bd3d68852a097295bc7fd7ff85333c0752d8e139d07a833cd6d64a2bc"
    sha256 cellar: :any,                 arm64_sonoma:  "e805719bd3d68852a097295bc7fd7ff85333c0752d8e139d07a833cd6d64a2bc"
    sha256 cellar: :any,                 sonoma:        "57cb35b69451c1283e03ea292daadc88d9575b0a864c1c86d094efa1d07b97d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0709440a70c3af78cc201b6020978f3bf371d898469e1885476f36b8b069031"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aed98d8947f872faae310c28bf5dd9c080dd62de8106d2cd2927faf79d300c43"
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