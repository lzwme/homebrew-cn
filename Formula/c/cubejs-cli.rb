class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.2.tgz"
  sha256 "aa4c6d3dd2cabf79d1603e3e73faa642dd2f1fa94188efcc1a48cbea2552f9a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8f3a798a0202bbc21a815919d1c240fd3f5b3e7a6aa8b47a8224313b4c0cc5a"
    sha256 cellar: :any,                 arm64_sonoma:  "e8f3a798a0202bbc21a815919d1c240fd3f5b3e7a6aa8b47a8224313b4c0cc5a"
    sha256 cellar: :any,                 arm64_ventura: "e8f3a798a0202bbc21a815919d1c240fd3f5b3e7a6aa8b47a8224313b4c0cc5a"
    sha256 cellar: :any,                 sonoma:        "858b9ca04a2c97de9c9ad3de8d8d4492ef6d611ea2570b952bc492e54f5b86e7"
    sha256 cellar: :any,                 ventura:       "858b9ca04a2c97de9c9ad3de8d8d4492ef6d611ea2570b952bc492e54f5b86e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45e62eca0b55a8d367bdd30da24236ed4b8ee4591ea36a583f4c0b7a081012e"
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