require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.40.tgz"
  sha256 "1c506e7e3de1c6e212cf4e603daae07a32c93f10b88d8cd8da79ab9a3f673c58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b8331773a1add77a7680484367ce989917baf1fd02deea495a4c4c349ebd8acd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632fa383d27edc4a04595dfc51bce830d8154e8a1d1483a635147acd95b82362"
    sha256 cellar: :any,                 arm64_big_sur:  "0515ee2afb0c56369815549e82cc5e8ebcb11a6bf7e371738dcc782c16cddf00"
    sha256 cellar: :any_skip_relocation, ventura:        "de43cf8451a070cf71e024b7bef850ddc29f72d1b046c7b101fef66385526375"
    sha256 cellar: :any_skip_relocation, monterey:       "de43cf8451a070cf71e024b7bef850ddc29f72d1b046c7b101fef66385526375"
    sha256 cellar: :any_skip_relocation, big_sur:        "de43cf8451a070cf71e024b7bef850ddc29f72d1b046c7b101fef66385526375"
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