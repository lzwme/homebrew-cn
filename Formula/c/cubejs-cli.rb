require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.15.tgz"
  sha256 "4a341a56c0e296b4f03f7864321f36ccd37b3cf0e7c22078c796db48c4953e24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e61a825fbd13ac6a6249358718eaa045705207d58cba33829f6350726623f65f"
    sha256 cellar: :any,                 arm64_ventura:  "e61a825fbd13ac6a6249358718eaa045705207d58cba33829f6350726623f65f"
    sha256 cellar: :any,                 arm64_monterey: "e61a825fbd13ac6a6249358718eaa045705207d58cba33829f6350726623f65f"
    sha256 cellar: :any,                 sonoma:         "0a894d84bc28dec7981972fff6c267d586d3754b3c6fff740305682c256adcb2"
    sha256 cellar: :any,                 ventura:        "0a894d84bc28dec7981972fff6c267d586d3754b3c6fff740305682c256adcb2"
    sha256 cellar: :any,                 monterey:       "0a894d84bc28dec7981972fff6c267d586d3754b3c6fff740305682c256adcb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587e5569db8a8627aa4b1934df290b98f43db2fc8f7142b4b872c1b46a6416ba"
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