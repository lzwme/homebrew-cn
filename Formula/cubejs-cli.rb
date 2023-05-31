require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.19.tgz"
  sha256 "05d0798f2bf3338a4b1f7542891ff911d5c073fa93c069743de7abb5d3147eb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad6b54dbc855d7cf7dbd23e08e675ea8fc4f1f005dded046480a951fd6455b9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad6b54dbc855d7cf7dbd23e08e675ea8fc4f1f005dded046480a951fd6455b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad6b54dbc855d7cf7dbd23e08e675ea8fc4f1f005dded046480a951fd6455b9f"
    sha256 cellar: :any_skip_relocation, ventura:        "49d853d5cc4cbee37587d7e1adddb82687b8c4f4a8b24e67cf1cf8d2709cbf89"
    sha256 cellar: :any_skip_relocation, monterey:       "49d853d5cc4cbee37587d7e1adddb82687b8c4f4a8b24e67cf1cf8d2709cbf89"
    sha256 cellar: :any_skip_relocation, big_sur:        "49d853d5cc4cbee37587d7e1adddb82687b8c4f4a8b24e67cf1cf8d2709cbf89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad6b54dbc855d7cf7dbd23e08e675ea8fc4f1f005dded046480a951fd6455b9f"
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