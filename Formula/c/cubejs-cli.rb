class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.1.6.tgz"
  sha256 "933fa6db886fe9df16d431a97c49a2f80dcca4a65b4e93c2ac62c94d4ca3e494"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5d0650ff8cb096b03473713ef10e4c0a53cf13b690ab53ed56a73862ea6b114"
    sha256 cellar: :any,                 arm64_sonoma:  "c5d0650ff8cb096b03473713ef10e4c0a53cf13b690ab53ed56a73862ea6b114"
    sha256 cellar: :any,                 arm64_ventura: "c5d0650ff8cb096b03473713ef10e4c0a53cf13b690ab53ed56a73862ea6b114"
    sha256 cellar: :any,                 sonoma:        "8b54356b80c64f8eba32747215212249081c8fd41e4850785a895b3dc3b4417f"
    sha256 cellar: :any,                 ventura:       "8b54356b80c64f8eba32747215212249081c8fd41e4850785a895b3dc3b4417f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4151b544ff4a168d332c4af0963185641219c1a5f1093f5021a24c0e8aa23a"
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