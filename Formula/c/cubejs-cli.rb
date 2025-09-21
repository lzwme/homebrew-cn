class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.70.tgz"
  sha256 "a69ea8ef05369c0170fc452415499e40e24469070d1a07b877eeff35bb3e57a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a16d342573cb90e39401dfd9f4fdfd9b29a6637ef6177b498a0ce79f09eca27"
    sha256 cellar: :any,                 arm64_sequoia: "c74b51159c010578c693b94b54c1c2cc17b3fa40484649cecc309ca9f87db669"
    sha256 cellar: :any,                 arm64_sonoma:  "c74b51159c010578c693b94b54c1c2cc17b3fa40484649cecc309ca9f87db669"
    sha256 cellar: :any,                 sonoma:        "ccd2a7c63593e9ef77a6b12a1832186f23cf9208c30a8f9d3a4875b0bc4270da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef9dd6b3e7932aaac4a26de8d211a2794901e5792bfa467f6f0444f2c1525d2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "451c0b58a9a9ebdf40619bb771f8f137c295552e345780b54446569996e570b8"
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