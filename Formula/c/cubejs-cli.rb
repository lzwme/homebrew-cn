class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.70.tgz"
  sha256 "9e51e1b14fead42bdbeb03b2c6422f1061a9936e544741c1f5279433b2cdade2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4281c878e8a3d6ef99bf8e8b4ffe4c887a20c40ea934b8bf0a275441934550f7"
    sha256 cellar: :any,                 arm64_ventura:  "4281c878e8a3d6ef99bf8e8b4ffe4c887a20c40ea934b8bf0a275441934550f7"
    sha256 cellar: :any,                 arm64_monterey: "4281c878e8a3d6ef99bf8e8b4ffe4c887a20c40ea934b8bf0a275441934550f7"
    sha256 cellar: :any,                 sonoma:         "72061756b05b7e25ed55d6120e1c75a995bde29c13e00fd0402d3ccd34882f1d"
    sha256 cellar: :any,                 ventura:        "72061756b05b7e25ed55d6120e1c75a995bde29c13e00fd0402d3ccd34882f1d"
    sha256 cellar: :any,                 monterey:       "72061756b05b7e25ed55d6120e1c75a995bde29c13e00fd0402d3ccd34882f1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9495df5804bcc093d76ee23891090aa470b6b3c46c4a78a9efe8c84c67f24d46"
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
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end