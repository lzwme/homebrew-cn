require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.15.tgz"
  sha256 "b6dde4a296020603d7e24b0ce51c4b732942bf9e43108e6f1545e56b5960a6fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92602bfe20b28a0d571e4144c24820cf0b8cb0dcb91bff352521bf77a87f0dd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92602bfe20b28a0d571e4144c24820cf0b8cb0dcb91bff352521bf77a87f0dd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92602bfe20b28a0d571e4144c24820cf0b8cb0dcb91bff352521bf77a87f0dd0"
    sha256 cellar: :any_skip_relocation, ventura:        "5439d644c949b68cf97a629c087f3b85dc56fb6d01b30eff12c8aea902ee03b0"
    sha256 cellar: :any_skip_relocation, monterey:       "5439d644c949b68cf97a629c087f3b85dc56fb6d01b30eff12c8aea902ee03b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5439d644c949b68cf97a629c087f3b85dc56fb6d01b30eff12c8aea902ee03b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92602bfe20b28a0d571e4144c24820cf0b8cb0dcb91bff352521bf77a87f0dd0"
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