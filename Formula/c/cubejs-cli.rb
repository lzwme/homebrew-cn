require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.58.tgz"
  sha256 "d41bd54f915be79afd15982b6cf4f99f0a732da5995185a1e6210b309323eec8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bcf8da86cbeff3dafa7c2ddd6fa20451e283e1a9c39179ac1ef834293e849a9f"
    sha256 cellar: :any, arm64_ventura:  "bcf8da86cbeff3dafa7c2ddd6fa20451e283e1a9c39179ac1ef834293e849a9f"
    sha256 cellar: :any, arm64_monterey: "bcf8da86cbeff3dafa7c2ddd6fa20451e283e1a9c39179ac1ef834293e849a9f"
    sha256 cellar: :any, sonoma:         "5658fc5beac43366e714fea2a682761761ce176b25ca58609bfaa565d7778755"
    sha256 cellar: :any, ventura:        "5658fc5beac43366e714fea2a682761761ce176b25ca58609bfaa565d7778755"
    sha256 cellar: :any, monterey:       "5658fc5beac43366e714fea2a682761761ce176b25ca58609bfaa565d7778755"
  end

  depends_on "node"
  uses_from_macos "zlib"

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