require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.34.38.tgz"
  sha256 "b9697049ecebe7469873481829667438216c8abf45e0ada121b9701dac0aadd0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "a09dd97e2763d91c6b40b3a98713878acc55c55b0b1c1043991524a3fe13cfa5"
    sha256 cellar: :any, arm64_ventura:  "a09dd97e2763d91c6b40b3a98713878acc55c55b0b1c1043991524a3fe13cfa5"
    sha256 cellar: :any, arm64_monterey: "a09dd97e2763d91c6b40b3a98713878acc55c55b0b1c1043991524a3fe13cfa5"
    sha256 cellar: :any, sonoma:         "404a2e5b50b5cf9b2d9723a3c35d0b4e8f4503fdc5d3f03e4fc968a54d1204d0"
    sha256 cellar: :any, ventura:        "404a2e5b50b5cf9b2d9723a3c35d0b4e8f4503fdc5d3f03e4fc968a54d1204d0"
    sha256 cellar: :any, monterey:       "404a2e5b50b5cf9b2d9723a3c35d0b4e8f4503fdc5d3f03e4fc968a54d1204d0"
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