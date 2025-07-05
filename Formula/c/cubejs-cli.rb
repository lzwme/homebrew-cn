class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.34.tgz"
  sha256 "f0f66db042cf2b4b5ebfcdba3ef275b7f97bca009ea98c737636773567a3623c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "967c3233fb7436d3138ec4a5f1d19f6967b1a3a5d84dbcf11a8d1e5976a6fc76"
    sha256 cellar: :any,                 arm64_sonoma:  "967c3233fb7436d3138ec4a5f1d19f6967b1a3a5d84dbcf11a8d1e5976a6fc76"
    sha256 cellar: :any,                 arm64_ventura: "967c3233fb7436d3138ec4a5f1d19f6967b1a3a5d84dbcf11a8d1e5976a6fc76"
    sha256 cellar: :any,                 sonoma:        "65ded3b39613b7d1c799892b981931189ce565dc8aaf6c886447567af8207cf8"
    sha256 cellar: :any,                 ventura:       "65ded3b39613b7d1c799892b981931189ce565dc8aaf6c886447567af8207cf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf4f15348c1a5236cad97f3dcf37841e4759af27a24ffce24063c69a5216f97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68e966aa98ae1bb6b829e93809becebe2c1f00c70746a49d27ff6aa2d8c67bda"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end