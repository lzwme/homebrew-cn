class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.40.tgz"
  sha256 "c3da48ad26a1b4bdccb4ac68c58abaeea824582d95cfabd9c07c82424aa4206c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f5aa4b773c6eacfa36597244d89b95251e5b62a6f13036de8004b9cea671dc5"
    sha256 cellar: :any,                 arm64_sonoma:  "1f5aa4b773c6eacfa36597244d89b95251e5b62a6f13036de8004b9cea671dc5"
    sha256 cellar: :any,                 arm64_ventura: "1f5aa4b773c6eacfa36597244d89b95251e5b62a6f13036de8004b9cea671dc5"
    sha256 cellar: :any,                 sonoma:        "4a5e481b25ba15764f4b933e9e282e6370d9929cf35d9980b4028ed6d31e0fe5"
    sha256 cellar: :any,                 ventura:       "4a5e481b25ba15764f4b933e9e282e6370d9929cf35d9980b4028ed6d31e0fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3246ed7346d28528196af1a5be147a9e8438738fa31a89780dce85a96cb5b6be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d28126a0cf73fb48a755ed5b6352445be386e45a26ab104b7097ba7fa65f868"
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