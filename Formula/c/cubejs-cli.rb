class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.75.tgz"
  sha256 "d34b80e78a393aad2c82f4b8e48b76e9c375162b4ab198eb4f3eb15cd5ad81f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb492a81506a54ec9229e4347ae8eeaebb34f416b68e0ca877e734d93871b387"
    sha256 cellar: :any,                 arm64_ventura:  "bb492a81506a54ec9229e4347ae8eeaebb34f416b68e0ca877e734d93871b387"
    sha256 cellar: :any,                 arm64_monterey: "bb492a81506a54ec9229e4347ae8eeaebb34f416b68e0ca877e734d93871b387"
    sha256 cellar: :any,                 sonoma:         "d3f658303ec72cf65e521292bdf12439fe58948d8636e99d893ebeb0c619389e"
    sha256 cellar: :any,                 ventura:        "d3f658303ec72cf65e521292bdf12439fe58948d8636e99d893ebeb0c619389e"
    sha256 cellar: :any,                 monterey:       "d3f658303ec72cf65e521292bdf12439fe58948d8636e99d893ebeb0c619389e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13dab7b2c38a0b59cdc9391a7d38816c752af147273bfe891524ecb98da06a6b"
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