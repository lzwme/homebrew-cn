class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.49.tgz"
  sha256 "6bcd1bfb9846f9df58e540980040d17ebc3995d01a32b1184b5b5ba408aa2104"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a50b9bcc92035cd8bdb1f00cc5075db062880ac53c333f2a540416fd4878a5b"
    sha256 cellar: :any,                 arm64_sonoma:  "8a50b9bcc92035cd8bdb1f00cc5075db062880ac53c333f2a540416fd4878a5b"
    sha256 cellar: :any,                 arm64_ventura: "8a50b9bcc92035cd8bdb1f00cc5075db062880ac53c333f2a540416fd4878a5b"
    sha256 cellar: :any,                 sonoma:        "8792cb1e62c3a950bccd95bc09bcf935e7a14b8cc37aee3b0858b9b997d214c3"
    sha256 cellar: :any,                 ventura:       "8792cb1e62c3a950bccd95bc09bcf935e7a14b8cc37aee3b0858b9b997d214c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e916319eeee9134fa2ef7adf8cd4758c1135ad9423ccb52ff425e17fa56159f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81a7250afb5b84eca08002c18481d0a0f6f8940f35d3bb22476537a44ddf26b1"
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