class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.25.tgz"
  sha256 "def354e3c1a0fa147de9a8780b66c5e4487b5b23e63db3bebc754351b896655a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "425ae1ef3b1609440a7dda79954a03cd858bcddc0d8c8bc3fcc6e49d5a42b5e1"
    sha256 cellar: :any,                 arm64_sonoma:  "425ae1ef3b1609440a7dda79954a03cd858bcddc0d8c8bc3fcc6e49d5a42b5e1"
    sha256 cellar: :any,                 arm64_ventura: "425ae1ef3b1609440a7dda79954a03cd858bcddc0d8c8bc3fcc6e49d5a42b5e1"
    sha256 cellar: :any,                 sonoma:        "79935b71703b281d8385d991f12f3e1d671df4d95ea5ef43ca1d6e73c3f94d6e"
    sha256 cellar: :any,                 ventura:       "79935b71703b281d8385d991f12f3e1d671df4d95ea5ef43ca1d6e73c3f94d6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a520d38bf7560e67b3c3babaaf0a870b9dbce716fa48c515dabe4f47a119e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275e88be7947fde89afe6c127dab1b33dcff8f27c8fc7e7fee831ea7c426b1c2"
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