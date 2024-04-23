require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.22.tgz"
  sha256 "e2a15b4b4ca82f616b0cf50b153d475df8512a7815059e24f98f6bc85848e6fc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0b537b3f2eb9e19d117156bc5f89fdb05a0bde5bf68f79cc9db7eadfd1c62ad1"
    sha256 cellar: :any,                 arm64_ventura:  "0b537b3f2eb9e19d117156bc5f89fdb05a0bde5bf68f79cc9db7eadfd1c62ad1"
    sha256 cellar: :any,                 arm64_monterey: "0b537b3f2eb9e19d117156bc5f89fdb05a0bde5bf68f79cc9db7eadfd1c62ad1"
    sha256 cellar: :any_skip_relocation, sonoma:         "dbb50ec24e05e88cc531872e1265b7bb8689d3838e3c9359a18f1b8ed976b51d"
    sha256 cellar: :any_skip_relocation, ventura:        "dbb50ec24e05e88cc531872e1265b7bb8689d3838e3c9359a18f1b8ed976b51d"
    sha256 cellar: :any_skip_relocation, monterey:       "dbb50ec24e05e88cc531872e1265b7bb8689d3838e3c9359a18f1b8ed976b51d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90937a983cbbcc60689034595fff7bf300cf621ccada6be4808b945db54505d0"
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