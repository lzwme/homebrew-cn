class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.53.tgz"
  sha256 "2ec7760a6c98545631cdac29f75147ee421bcceb3779f7a24df3de5b1a3aca84"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "001b99952930eb3740a45f500c16d90d77915df3d125247406bd0f6abdfe5211"
    sha256 cellar: :any,                 arm64_sonoma:  "001b99952930eb3740a45f500c16d90d77915df3d125247406bd0f6abdfe5211"
    sha256 cellar: :any,                 arm64_ventura: "001b99952930eb3740a45f500c16d90d77915df3d125247406bd0f6abdfe5211"
    sha256 cellar: :any,                 sonoma:        "f62f7b9203213b33ad3eb3e862bcec841aeecea08865ed8406303bf314137894"
    sha256 cellar: :any,                 ventura:       "f62f7b9203213b33ad3eb3e862bcec841aeecea08865ed8406303bf314137894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a60b47b7b9375b060313477b018a7a388cbe3b738c4f2006d86ece5fbea649f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0d246a9a0252fb96118fd2c07c9ba5449d3d72baf201c6c1fcaa5eb1f3c8398"
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