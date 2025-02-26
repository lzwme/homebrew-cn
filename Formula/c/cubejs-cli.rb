class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.11.tgz"
  sha256 "6d1521eeb55f44d7a28664756bd773417c7716c0b9bbd5d99f1b538922b9bff3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b9b57453742029b9f4e65e4fa236ea52de4c64216736c89ff016784979a6061a"
    sha256 cellar: :any,                 arm64_sonoma:  "b9b57453742029b9f4e65e4fa236ea52de4c64216736c89ff016784979a6061a"
    sha256 cellar: :any,                 arm64_ventura: "b9b57453742029b9f4e65e4fa236ea52de4c64216736c89ff016784979a6061a"
    sha256 cellar: :any,                 sonoma:        "0622cd20656c04d3c1af13397cd08d9e74e7f54cc0c27193f4a7800f04e082f5"
    sha256 cellar: :any,                 ventura:       "0622cd20656c04d3c1af13397cd08d9e74e7f54cc0c27193f4a7800f04e082f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91970938f164787a0e39da5e7fbfdcda316fa83d33ce5901644f685f66b9d47a"
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