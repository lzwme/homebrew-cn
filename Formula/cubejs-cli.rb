require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.36.tgz"
  sha256 "97185c4c3bcac46bf99e1086b642f30f154e7668b6f6e920fd498b440802cf66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f98797487d8a55f75df80f917b5b0c2e4d51be24cdcbdb29e462deef1c27279a"
    sha256 cellar: :any, arm64_monterey: "f98797487d8a55f75df80f917b5b0c2e4d51be24cdcbdb29e462deef1c27279a"
    sha256 cellar: :any, arm64_big_sur:  "f98797487d8a55f75df80f917b5b0c2e4d51be24cdcbdb29e462deef1c27279a"
    sha256 cellar: :any, ventura:        "4ebfda61107cf5de7b8cf24420fc627c150470ee5ff32c6c52d78c77a4310bd4"
    sha256 cellar: :any, monterey:       "4ebfda61107cf5de7b8cf24420fc627c150470ee5ff32c6c52d78c77a4310bd4"
    sha256 cellar: :any, big_sur:        "4ebfda61107cf5de7b8cf24420fc627c150470ee5ff32c6c52d78c77a4310bd4"
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