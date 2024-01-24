require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.47.tgz"
  sha256 "35dce35efb07256852458acfdae1fa3d8eabd5bc40f70be7992dd70d28ba4574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "841cc35cb41b856c884e7bbe50243456ab749b2059de54dc098592a9a7f0dfdb"
    sha256 cellar: :any, arm64_ventura:  "841cc35cb41b856c884e7bbe50243456ab749b2059de54dc098592a9a7f0dfdb"
    sha256 cellar: :any, arm64_monterey: "841cc35cb41b856c884e7bbe50243456ab749b2059de54dc098592a9a7f0dfdb"
    sha256 cellar: :any, sonoma:         "cdfe63c117ccf4639b3ef7ea008641aa0350d4b2f681c8afa0c1c4bdf0d00b32"
    sha256 cellar: :any, ventura:        "cdfe63c117ccf4639b3ef7ea008641aa0350d4b2f681c8afa0c1c4bdf0d00b32"
    sha256 cellar: :any, monterey:       "cdfe63c117ccf4639b3ef7ea008641aa0350d4b2f681c8afa0c1c4bdf0d00b32"
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