require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.24.tgz"
  sha256 "ac87b584dff29c984439dc2900bf9a7b2ec785a7d0f8346d0bbbeb420c2bd7de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ecc0f6d2ada8bb5446df0d7ca8aeaee0adb19a6ac511cdd54cf30b834cdcf7a1"
    sha256 cellar: :any,                 arm64_ventura:  "ecc0f6d2ada8bb5446df0d7ca8aeaee0adb19a6ac511cdd54cf30b834cdcf7a1"
    sha256 cellar: :any,                 arm64_monterey: "ecc0f6d2ada8bb5446df0d7ca8aeaee0adb19a6ac511cdd54cf30b834cdcf7a1"
    sha256 cellar: :any,                 sonoma:         "7d9a5ea9c513ffb68a28cc58608fa841c9e434c51f3b401552c30d526be1d830"
    sha256 cellar: :any,                 ventura:        "7d9a5ea9c513ffb68a28cc58608fa841c9e434c51f3b401552c30d526be1d830"
    sha256 cellar: :any,                 monterey:       "7d9a5ea9c513ffb68a28cc58608fa841c9e434c51f3b401552c30d526be1d830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4b3fd892253648fc1c5a36121444ec5151e066a763bd5ed00b17494d6661f81"
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