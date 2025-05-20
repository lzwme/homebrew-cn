class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.16.tgz"
  sha256 "82abae8a55ac990c21925b1f3c54eaaa43a53a494dfd0d4332b822fbd14092dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "870c46999c690181d3c3857dfaa3bba9210cc4e3436b65396b7d63903ed32dea"
    sha256 cellar: :any,                 arm64_sonoma:  "870c46999c690181d3c3857dfaa3bba9210cc4e3436b65396b7d63903ed32dea"
    sha256 cellar: :any,                 arm64_ventura: "870c46999c690181d3c3857dfaa3bba9210cc4e3436b65396b7d63903ed32dea"
    sha256 cellar: :any,                 sonoma:        "a291388d37410f4594e4f148733f78a48d04e42f08ceea4a882b94f309237512"
    sha256 cellar: :any,                 ventura:       "a291388d37410f4594e4f148733f78a48d04e42f08ceea4a882b94f309237512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0844043d43db54f88eca89ee88a737d67e64c7ab5c4288746d1f5783d402aa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "659f56a333271763555331379e4ea28f176100f2b780d0965879ab072635bf06"
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