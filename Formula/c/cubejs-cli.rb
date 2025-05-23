class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.17.tgz"
  sha256 "d0ac9ee6171f4fad302635f356843b852e612d3543e8c7257a9e7343985f13e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8766296172942ef29cee9de4ad130128625ba088c32a9229d27238cd0e566df"
    sha256 cellar: :any,                 arm64_sonoma:  "f8766296172942ef29cee9de4ad130128625ba088c32a9229d27238cd0e566df"
    sha256 cellar: :any,                 arm64_ventura: "f8766296172942ef29cee9de4ad130128625ba088c32a9229d27238cd0e566df"
    sha256 cellar: :any,                 sonoma:        "9b6512669f555d51ca79d8cccc773a26a5bdd0f6252368bacb1d2f58f8e0e527"
    sha256 cellar: :any,                 ventura:       "9b6512669f555d51ca79d8cccc773a26a5bdd0f6252368bacb1d2f58f8e0e527"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "969f622f78064017661556fb74959df86f86e947c9a6b8e4d473d446210f028c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0baa0ea7fdc7e7641c7bf4152800c89398c1670c018ed692e9167eb11b7ab820"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end