class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.72.tgz"
  sha256 "1dfed53b5a5664c250bd6bb9e8222e1b1d67b34fb53045d734fb8bcba9fc19f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1632a8fcad0d57ef8bed723cc229e9c525313981a9b8e6f0c054c6969dbc0827"
    sha256 cellar: :any,                 arm64_sequoia: "e6af1f5ef391fe246ade62c58883244717e93358c65e4c7109b77830c8895448"
    sha256 cellar: :any,                 arm64_sonoma:  "e6af1f5ef391fe246ade62c58883244717e93358c65e4c7109b77830c8895448"
    sha256 cellar: :any,                 sonoma:        "a5602f4d3f8c9610b2fa83f3653a959251fd4eefb70af8b412488359ba8f4b33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53f538d494e04b8e8f18158f48b14763fd19775fae17ce9a7757ca02c5e58f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdcc9ed148ae56f78da7774eb661eb8a1f48748fc62cdf86c2c63d3f3193d8a8"
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