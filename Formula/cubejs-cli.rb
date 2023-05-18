require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.8.tgz"
  sha256 "5d8f7d2910ec0bfda7bb28f84f11fb941ed4b545b43ae68dea2b8fc8505c70dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a5f664fe76571959a6445ac3d3d1566399db1800c5d97801fa6749b347ebb08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a5f664fe76571959a6445ac3d3d1566399db1800c5d97801fa6749b347ebb08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a5f664fe76571959a6445ac3d3d1566399db1800c5d97801fa6749b347ebb08"
    sha256 cellar: :any_skip_relocation, ventura:        "d34e82ad8be2e364ac71a92cd40e2e7627f0a8c92d9688af9c3e5d4ff937ba8e"
    sha256 cellar: :any_skip_relocation, monterey:       "d34e82ad8be2e364ac71a92cd40e2e7627f0a8c92d9688af9c3e5d4ff937ba8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d34e82ad8be2e364ac71a92cd40e2e7627f0a8c92d9688af9c3e5d4ff937ba8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a5f664fe76571959a6445ac3d3d1566399db1800c5d97801fa6749b347ebb08"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end