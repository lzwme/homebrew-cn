require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.0.tgz"
  sha256 "2e72b4a6269cfdb6795c10e321a09cf0351d51189c2e28f5e2a7b2378bf8f57e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38b0873a7dc4ce646072bcf6f31532b3a9c62654804316f5006dc4b7df25ca68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38b0873a7dc4ce646072bcf6f31532b3a9c62654804316f5006dc4b7df25ca68"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38b0873a7dc4ce646072bcf6f31532b3a9c62654804316f5006dc4b7df25ca68"
    sha256 cellar: :any_skip_relocation, ventura:        "1249ad6e5819bdbc50793b6b238d8c29f41f1ee0257e9dc4149f9e5c9e72056a"
    sha256 cellar: :any_skip_relocation, monterey:       "1249ad6e5819bdbc50793b6b238d8c29f41f1ee0257e9dc4149f9e5c9e72056a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1249ad6e5819bdbc50793b6b238d8c29f41f1ee0257e9dc4149f9e5c9e72056a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b0873a7dc4ce646072bcf6f31532b3a9c62654804316f5006dc4b7df25ca68"
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