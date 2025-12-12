class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.5.14.tgz"
  sha256 "ec1bb9add09ff5a65b8d01fe9589b9cc1b874b1f5e30f3ad302f6b2eb9b0b303"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a79725be199afcb5f6b437d6f535a9d9fd8ae015b904826fb43c201b3dd2d432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e3c95ee4e5f99e861a02934161cdf89286232473342948cfe3d486c631513af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e3c95ee4e5f99e861a02934161cdf89286232473342948cfe3d486c631513af"
    sha256 cellar: :any_skip_relocation, sonoma:        "afe2b8796a7c01325babc82626a39e22cb0c65c531e05a4d3386e02eb38245cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecdb3c0756b7ac496888d76d30ef8ac0ab185a41285a9c0fb6ac1b31cd209de6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecdb3c0756b7ac496888d76d30ef8ac0ab185a41285a9c0fb6ac1b31cd209de6"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end