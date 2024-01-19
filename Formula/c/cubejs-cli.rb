require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.46.tgz"
  sha256 "a055f99a6f7dd294b78e0eb065a33e52bf76dec9567861f30837aa502e17e4b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bceec6feedd757977ce7e33cba1b28929f1eb438c2e9ef035e7ea4c26a62f53a"
    sha256 cellar: :any, arm64_ventura:  "bceec6feedd757977ce7e33cba1b28929f1eb438c2e9ef035e7ea4c26a62f53a"
    sha256 cellar: :any, arm64_monterey: "bceec6feedd757977ce7e33cba1b28929f1eb438c2e9ef035e7ea4c26a62f53a"
    sha256 cellar: :any, sonoma:         "80881f0bf660bbf9d549d6ce4101a49327a731ff20ef9591a2c6f0eda368d47c"
    sha256 cellar: :any, ventura:        "80881f0bf660bbf9d549d6ce4101a49327a731ff20ef9591a2c6f0eda368d47c"
    sha256 cellar: :any, monterey:       "80881f0bf660bbf9d549d6ce4101a49327a731ff20ef9591a2c6f0eda368d47c"
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