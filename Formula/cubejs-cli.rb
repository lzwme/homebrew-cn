require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.38.tgz"
  sha256 "10d24a365f480a9193a66c3251e72b184c854116af6107fd7afa12eeeed63068"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "332403a91cd4e16e4e5fe46253b8b3fd0ecfafa7698b84da0483729071f8dd29"
    sha256 cellar: :any, arm64_monterey: "332403a91cd4e16e4e5fe46253b8b3fd0ecfafa7698b84da0483729071f8dd29"
    sha256 cellar: :any, arm64_big_sur:  "332403a91cd4e16e4e5fe46253b8b3fd0ecfafa7698b84da0483729071f8dd29"
    sha256 cellar: :any, ventura:        "22093b37ebe4c4f9d0c6dafab60bcfa5a8afe7b835f7a116703d8658ab00d93a"
    sha256 cellar: :any, monterey:       "22093b37ebe4c4f9d0c6dafab60bcfa5a8afe7b835f7a116703d8658ab00d93a"
    sha256 cellar: :any, big_sur:        "22093b37ebe4c4f9d0c6dafab60bcfa5a8afe7b835f7a116703d8658ab00d93a"
  end

  depends_on "node"

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