require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.22.tgz"
  sha256 "336c1843c51176bfa09880b5c9d2b2459603240a891b91082319690588ed50bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1947393afa6c0ba298581fa5d2132bf83f585271f470b9e044285745624b09e9"
    sha256 cellar: :any, arm64_ventura:  "1947393afa6c0ba298581fa5d2132bf83f585271f470b9e044285745624b09e9"
    sha256 cellar: :any, arm64_monterey: "1947393afa6c0ba298581fa5d2132bf83f585271f470b9e044285745624b09e9"
    sha256 cellar: :any, sonoma:         "8bde0b987829dd0028be86ea559570bfc3ef3fe44ebaf3d7dc4fc0f297e9dafe"
    sha256 cellar: :any, ventura:        "8bde0b987829dd0028be86ea559570bfc3ef3fe44ebaf3d7dc4fc0f297e9dafe"
    sha256 cellar: :any, monterey:       "8bde0b987829dd0028be86ea559570bfc3ef3fe44ebaf3d7dc4fc0f297e9dafe"
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