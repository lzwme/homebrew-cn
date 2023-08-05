require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.43.tgz"
  sha256 "d011d6a4576a758ad42e321559ccca197dd2e996bd3c3d37975a650d4623d58e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a4b8f06ea7404c600d22359eaab3f7463459609fe33090aba372dcb5d60f9c3a"
    sha256 cellar: :any, arm64_monterey: "a4b8f06ea7404c600d22359eaab3f7463459609fe33090aba372dcb5d60f9c3a"
    sha256 cellar: :any, arm64_big_sur:  "a4b8f06ea7404c600d22359eaab3f7463459609fe33090aba372dcb5d60f9c3a"
    sha256 cellar: :any, ventura:        "6e412713688d3ea35443e3ad95399560568130fe0d9c2e2b8505d535af734f26"
    sha256 cellar: :any, monterey:       "6e412713688d3ea35443e3ad95399560568130fe0d9c2e2b8505d535af734f26"
    sha256 cellar: :any, big_sur:        "6e412713688d3ea35443e3ad95399560568130fe0d9c2e2b8505d535af734f26"
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