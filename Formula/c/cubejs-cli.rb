class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.9.tgz"
  sha256 "3b1121cf4ecf337e81f719b960438df1c3f1b8fb1eda18ec973f7a29a8d323d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "989be2542851deb6e1dd649cd3b6289d9389dd0e9833e6323f5b41e2d77a096a"
    sha256 cellar: :any,                 arm64_sonoma:  "989be2542851deb6e1dd649cd3b6289d9389dd0e9833e6323f5b41e2d77a096a"
    sha256 cellar: :any,                 arm64_ventura: "989be2542851deb6e1dd649cd3b6289d9389dd0e9833e6323f5b41e2d77a096a"
    sha256 cellar: :any,                 sonoma:        "577a62ac9a868c6def6aaa9c7606c759e4a16190338e861a0ed79ffdd77a1a01"
    sha256 cellar: :any,                 ventura:       "577a62ac9a868c6def6aaa9c7606c759e4a16190338e861a0ed79ffdd77a1a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22ba6222556a96b645cb3e31d7593d9456bdee0e111fc9298d4b53c1ed7091de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08086358e1986ecba0e9827e7be22870f031e5b1d3b0e2f55bd2afb9900e448e"
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