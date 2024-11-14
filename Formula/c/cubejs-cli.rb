class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.5.tgz"
  sha256 "9ff999378bc0bb6220ccde2bae80a69d21b5472c7113fa82bd2b055c25ea8a45"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "67696ec69fd1f2616ed5bcdc445ac97b6c51500a7bfd0a6d0d729185d22a26a7"
    sha256 cellar: :any,                 arm64_sonoma:  "67696ec69fd1f2616ed5bcdc445ac97b6c51500a7bfd0a6d0d729185d22a26a7"
    sha256 cellar: :any,                 arm64_ventura: "67696ec69fd1f2616ed5bcdc445ac97b6c51500a7bfd0a6d0d729185d22a26a7"
    sha256 cellar: :any,                 sonoma:        "60a331bdf239d02c9cf0701b5534978d27d3a314b1fa426edb8ab0bc1f80c8f2"
    sha256 cellar: :any,                 ventura:       "60a331bdf239d02c9cf0701b5534978d27d3a314b1fa426edb8ab0bc1f80c8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36383204cd567829d3358c98e561663e84ba6296f1e07ebfb5d2c88922189d4e"
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