class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.21.tgz"
  sha256 "e6ebb1606c15753a05bf9e0470ef7af6fe41bd648f5d81e6c8c513a65ef9a94b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "723a933bad4f793f56ad2c0015ebac0ffb701abbad2966e364ca9bb222ba9108"
    sha256 cellar: :any,                 arm64_sonoma:  "723a933bad4f793f56ad2c0015ebac0ffb701abbad2966e364ca9bb222ba9108"
    sha256 cellar: :any,                 arm64_ventura: "723a933bad4f793f56ad2c0015ebac0ffb701abbad2966e364ca9bb222ba9108"
    sha256 cellar: :any,                 sonoma:        "877f3f27b0b1c2ee973c30d54aabe86edcfd9574a9c94cf2ddf2c394faa44bd3"
    sha256 cellar: :any,                 ventura:       "877f3f27b0b1c2ee973c30d54aabe86edcfd9574a9c94cf2ddf2c394faa44bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2ff2a3748967ab10b55990d9cca9a1987f51d42292caffb717aa20a45b7085a"
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