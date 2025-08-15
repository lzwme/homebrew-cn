class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.52.tgz"
  sha256 "64f22e974ea60344e0fae73fd47d3eb93825b407054e43808996bc3597b492a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ca47e90f937c46e7e9beb423ec1d5d0d7ac7c88099662709f662712804708206"
    sha256 cellar: :any,                 arm64_sonoma:  "ca47e90f937c46e7e9beb423ec1d5d0d7ac7c88099662709f662712804708206"
    sha256 cellar: :any,                 arm64_ventura: "ca47e90f937c46e7e9beb423ec1d5d0d7ac7c88099662709f662712804708206"
    sha256 cellar: :any,                 sonoma:        "5d2aa0ac42104fcdd338963ea427dad6dff9e53a1ada0777fb0a28257e9657fd"
    sha256 cellar: :any,                 ventura:       "5d2aa0ac42104fcdd338963ea427dad6dff9e53a1ada0777fb0a28257e9657fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd6b682f305ed657f1f755226b0bc96a7f1c1bc0ad57e6e55056c2b3674a5157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32d261427fe15db2e3f1ae1afad98dc317fed837f3344dabcc461d3be78b7946"
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