require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.10.tgz"
  sha256 "a9772690dabd8cba24ac87e3c0e27f2cb03f45b47a1675bb1af7d07de17391d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "ef0683edd6ddbcbd872114021ecae5d64e740d0819dae93adfc4fd8152002954"
    sha256 cellar: :any, arm64_ventura:  "ef0683edd6ddbcbd872114021ecae5d64e740d0819dae93adfc4fd8152002954"
    sha256 cellar: :any, arm64_monterey: "ef0683edd6ddbcbd872114021ecae5d64e740d0819dae93adfc4fd8152002954"
    sha256 cellar: :any, sonoma:         "746ffc7c085af05f0317b433a5c8787b0d2d9a4174038a61c5445a82834a1c2c"
    sha256 cellar: :any, ventura:        "746ffc7c085af05f0317b433a5c8787b0d2d9a4174038a61c5445a82834a1c2c"
    sha256 cellar: :any, monterey:       "746ffc7c085af05f0317b433a5c8787b0d2d9a4174038a61c5445a82834a1c2c"
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