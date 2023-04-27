require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-14.3.1.tgz"
  sha256 "577b743e6eb07f3275642a4bb1e5e642c7bdf54a65a99ea2719deec3ce927a47"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "ec1af073241a0e86aacae8666bd994b8684855a218c8b75ce21999983efa25d9"
    sha256                               arm64_monterey: "a4abc332b9f4bead48e671d0d53dd6e8f7dc24c1a5ab04fd8e06a730d836569f"
    sha256                               arm64_big_sur:  "e7684e7f68414901e5874fa2346d58aa47aa26af15d6f94ee34384584a0c9973"
    sha256                               ventura:        "b6931d903b363747d8b01115d1c6fda7d16512f7605205266d0db4dfdf1c9e55"
    sha256                               monterey:       "3024ebb796038198fbf96beaa38d547e1d7aaf59bfe1e57d58de3af8229f1ecf"
    sha256                               big_sur:        "d4377f291a800693dc9d85ba3019690c7ee6f1a81e51b2093e3a37d991f82878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ad8a068e8bc8e5542e9229d659642ab1a78eb9dd38295fa481eb3d6d2b8385"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end