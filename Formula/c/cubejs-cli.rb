require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.60.tgz"
  sha256 "d7e67191fdcb14c982b784138d8cf6e635f5c33dcd97e6ae348907700efd80f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5c640b639946ac26ccddc88cb7389f60e85f1f2100c92e70d9f62c0183d01f83"
    sha256 cellar: :any,                 arm64_ventura:  "5c640b639946ac26ccddc88cb7389f60e85f1f2100c92e70d9f62c0183d01f83"
    sha256 cellar: :any,                 arm64_monterey: "5c640b639946ac26ccddc88cb7389f60e85f1f2100c92e70d9f62c0183d01f83"
    sha256 cellar: :any,                 sonoma:         "3d2b9a915050736a4428fa2acc9aa4df8c140058160d33f5753a5e659aba004d"
    sha256 cellar: :any,                 ventura:        "3d2b9a915050736a4428fa2acc9aa4df8c140058160d33f5753a5e659aba004d"
    sha256 cellar: :any,                 monterey:       "3d2b9a915050736a4428fa2acc9aa4df8c140058160d33f5753a5e659aba004d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89701de660f29634ae4e85012c064e692fae738804f4ee16b37f5847d4c87ace"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end