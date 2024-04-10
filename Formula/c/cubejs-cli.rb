require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.10.tgz"
  sha256 "b079dbda3119e5636c555f39badc022f464f099bc96fdfc9948594c4dac2504d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "563112d923d51cef822cea8e112fd310222c0c478ded1ac2bf28d86902ddc4b4"
    sha256 cellar: :any,                 arm64_ventura:  "563112d923d51cef822cea8e112fd310222c0c478ded1ac2bf28d86902ddc4b4"
    sha256 cellar: :any,                 arm64_monterey: "563112d923d51cef822cea8e112fd310222c0c478ded1ac2bf28d86902ddc4b4"
    sha256 cellar: :any,                 sonoma:         "50e58a98c0e93621170b5885dfe858bee9c63e4bfc94fe0ef385071cdccdc5ee"
    sha256 cellar: :any,                 ventura:        "50e58a98c0e93621170b5885dfe858bee9c63e4bfc94fe0ef385071cdccdc5ee"
    sha256 cellar: :any,                 monterey:       "50e58a98c0e93621170b5885dfe858bee9c63e4bfc94fe0ef385071cdccdc5ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbbff966fd785ab80842bc1c43bdefe061236b4911c7268b13d8f67dee3d25f0"
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