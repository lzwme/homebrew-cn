require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.12.tgz"
  sha256 "16b34c8563d92e6317d1f7bda923339ed68835a9e6bdc140209a1404eae8162b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf0ec67748df7300a6045db21772c284311eafd911c8c845afbd47c98d2e23db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0ec67748df7300a6045db21772c284311eafd911c8c845afbd47c98d2e23db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf0ec67748df7300a6045db21772c284311eafd911c8c845afbd47c98d2e23db"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab35303c6acc3e5a2bbd31e44518f6c1af6c1bddf1797ad03e94b99ec8262e9"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab35303c6acc3e5a2bbd31e44518f6c1af6c1bddf1797ad03e94b99ec8262e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ab35303c6acc3e5a2bbd31e44518f6c1af6c1bddf1797ad03e94b99ec8262e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf0ec67748df7300a6045db21772c284311eafd911c8c845afbd47c98d2e23db"
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