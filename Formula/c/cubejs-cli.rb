class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.3.tgz"
  sha256 "032a1ae157b1d6f6ebc9c3f16cc90769f7f32295ed572839d23c921c046a3bc6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8d425c52ff032d0fa3bdb4da5d23173f342dfaa8471c8683326d4d266cbe6302"
    sha256 cellar: :any,                 arm64_sonoma:  "8d425c52ff032d0fa3bdb4da5d23173f342dfaa8471c8683326d4d266cbe6302"
    sha256 cellar: :any,                 arm64_ventura: "8d425c52ff032d0fa3bdb4da5d23173f342dfaa8471c8683326d4d266cbe6302"
    sha256 cellar: :any,                 sonoma:        "19399dc245fc4b4242c9d5c0471ce3d92ab9dbebb7aa9b20d2699f6760f958e3"
    sha256 cellar: :any,                 ventura:       "19399dc245fc4b4242c9d5c0471ce3d92ab9dbebb7aa9b20d2699f6760f958e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecc8f4b5d1ba47df48c33a7a8e82466e4edea5142eb2deef86f73a09daffeeed"
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