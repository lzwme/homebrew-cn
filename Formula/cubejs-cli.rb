require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.7.tgz"
  sha256 "c2d97ec76542b8cb2171a371caa623428d4707313420918f280cba8cd0a7de4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8a2d0ca0b5c5ad9611b319a859299d8c66e4d5e4d3e301ea126c72e9aac48c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e8a2d0ca0b5c5ad9611b319a859299d8c66e4d5e4d3e301ea126c72e9aac48c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e8a2d0ca0b5c5ad9611b319a859299d8c66e4d5e4d3e301ea126c72e9aac48c"
    sha256 cellar: :any_skip_relocation, ventura:        "8e4484f798bff3b4b5f30b3860f6285ff93e5e92eb4b03fa635bf8b6abab3ea9"
    sha256 cellar: :any_skip_relocation, monterey:       "8e4484f798bff3b4b5f30b3860f6285ff93e5e92eb4b03fa635bf8b6abab3ea9"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e4484f798bff3b4b5f30b3860f6285ff93e5e92eb4b03fa635bf8b6abab3ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e8a2d0ca0b5c5ad9611b319a859299d8c66e4d5e4d3e301ea126c72e9aac48c"
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