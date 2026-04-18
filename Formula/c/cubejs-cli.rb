class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.36.tgz"
  sha256 "e06a4d992101fdbaca27dd5916a428534be09fab58ff9a832b51312f83450453"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "148508ab696f9670a229d78bacd926d60d6233b13c53af5274aa1e1bc9bfc2b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb147bc9c0047d265343393a65d43c738b1db8444bb9ec60803718d677432429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb147bc9c0047d265343393a65d43c738b1db8444bb9ec60803718d677432429"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f941210136f0f52233c728c4cdf7cb2eec4e90944d4b07e6f53d8329c7ef85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddd995d5ba1ba541e135d762eb394ee2d1fa64222602ecc93dac5226d2dad697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddd995d5ba1ba541e135d762eb394ee2d1fa64222602ecc93dac5226d2dad697"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end