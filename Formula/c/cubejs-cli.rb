require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.53.tgz"
  sha256 "fc31da782450ef374c75bbc82d9d613836afd420fd8287e0962868324ecf27c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e06ce0c2b4efb5ae16821d778b83d44593aadc6a555fe73ebfc8a5a1d2e396e9"
    sha256 cellar: :any, arm64_ventura:  "e06ce0c2b4efb5ae16821d778b83d44593aadc6a555fe73ebfc8a5a1d2e396e9"
    sha256 cellar: :any, arm64_monterey: "e06ce0c2b4efb5ae16821d778b83d44593aadc6a555fe73ebfc8a5a1d2e396e9"
    sha256 cellar: :any, sonoma:         "60145af796ba520d5c118bedeb79018e7298582a5f8bd8ab15992125dd7d1c75"
    sha256 cellar: :any, ventura:        "60145af796ba520d5c118bedeb79018e7298582a5f8bd8ab15992125dd7d1c75"
    sha256 cellar: :any, monterey:       "d7594af36d6efa33cd1d0293eae3d966bd1ffe0b4ab86a55aa91fce8ef579dc1"
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