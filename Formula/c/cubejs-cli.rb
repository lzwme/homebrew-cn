require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.52.tgz"
  sha256 "22da61eee1cb8e87dd042047e9f78d149a3600bc3c09d1afbfbc29586a5e9ebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7dfed9a16462b7c06695291b54dbcaa5b63f5fe86e0588be2050f3e4624a8697"
    sha256 cellar: :any,                 arm64_ventura:  "7dfed9a16462b7c06695291b54dbcaa5b63f5fe86e0588be2050f3e4624a8697"
    sha256 cellar: :any,                 arm64_monterey: "7dfed9a16462b7c06695291b54dbcaa5b63f5fe86e0588be2050f3e4624a8697"
    sha256 cellar: :any,                 sonoma:         "dcba17f06fb7845f73ca6ef8e7048b3369daebb60b7d1f3e67acabd22c949e6c"
    sha256 cellar: :any,                 ventura:        "dcba17f06fb7845f73ca6ef8e7048b3369daebb60b7d1f3e67acabd22c949e6c"
    sha256 cellar: :any,                 monterey:       "dcba17f06fb7845f73ca6ef8e7048b3369daebb60b7d1f3e67acabd22c949e6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2bfed67d5166f3f8f56d29242479ce9048500a362451f7b44096dc529b0632"
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