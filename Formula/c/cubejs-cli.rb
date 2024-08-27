class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.77.tgz"
  sha256 "89d38ecfe826f9fc103d967075f842241a465508e1f1a11bb0762c26c60ef228"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ca61422a1216b51594ec818fd0efa8cfc437cc565fb64810ddb1735d8913b25"
    sha256 cellar: :any,                 arm64_ventura:  "6ca61422a1216b51594ec818fd0efa8cfc437cc565fb64810ddb1735d8913b25"
    sha256 cellar: :any,                 arm64_monterey: "6ca61422a1216b51594ec818fd0efa8cfc437cc565fb64810ddb1735d8913b25"
    sha256 cellar: :any,                 sonoma:         "f38875f9ab506565f50754e2872fe951fde478bf87ef7daef3779482eeb3a6f2"
    sha256 cellar: :any,                 ventura:        "f38875f9ab506565f50754e2872fe951fde478bf87ef7daef3779482eeb3a6f2"
    sha256 cellar: :any,                 monterey:       "f38875f9ab506565f50754e2872fe951fde478bf87ef7daef3779482eeb3a6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfd5440c22e5849b2ff2a2098d42d36aa0928132802f38e1c6df715e50fbaa6a"
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