require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.2.tgz"
  sha256 "4e0585a6bfad2e5ca26fddce470ec4c1d8a9070fd86bb19e57afad8e03efe626"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40cd2c4fdf67c42e52f8f1e24370505414f13013fba95a48abc3f08fe799512c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40cd2c4fdf67c42e52f8f1e24370505414f13013fba95a48abc3f08fe799512c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40cd2c4fdf67c42e52f8f1e24370505414f13013fba95a48abc3f08fe799512c"
    sha256 cellar: :any_skip_relocation, ventura:        "f107726c7fab44b22ef195106194a6cb794404f0e7acd2f8bab205be173742eb"
    sha256 cellar: :any_skip_relocation, monterey:       "f107726c7fab44b22ef195106194a6cb794404f0e7acd2f8bab205be173742eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "f107726c7fab44b22ef195106194a6cb794404f0e7acd2f8bab205be173742eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40cd2c4fdf67c42e52f8f1e24370505414f13013fba95a48abc3f08fe799512c"
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