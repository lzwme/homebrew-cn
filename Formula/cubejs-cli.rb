require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.22.tgz"
  sha256 "64583c65fdff818dccb1c53621776e7637f2179ed946cd87cfc774d3de149354"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f76e57621cab9bbc77da65c294e6418d4ce1b26be854b37e205c5879549dcba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f76e57621cab9bbc77da65c294e6418d4ce1b26be854b37e205c5879549dcba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f76e57621cab9bbc77da65c294e6418d4ce1b26be854b37e205c5879549dcba"
    sha256 cellar: :any_skip_relocation, ventura:        "55c0deca61835de2f05e6224f09651b181162feab2593032c7f0144cdb299566"
    sha256 cellar: :any_skip_relocation, monterey:       "55c0deca61835de2f05e6224f09651b181162feab2593032c7f0144cdb299566"
    sha256 cellar: :any_skip_relocation, big_sur:        "55c0deca61835de2f05e6224f09651b181162feab2593032c7f0144cdb299566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f76e57621cab9bbc77da65c294e6418d4ce1b26be854b37e205c5879549dcba"
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