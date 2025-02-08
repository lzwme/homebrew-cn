class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.2.3.tgz"
  sha256 "9a81e23a3edc47137c5ae8aac1f47290f46c5ee9c7938d2a54b651745f6da5ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87febda07d382a6a429cf4abf942e0d7655dbdb49fba443fc0b93c834c5bab50"
    sha256 cellar: :any,                 arm64_sonoma:  "87febda07d382a6a429cf4abf942e0d7655dbdb49fba443fc0b93c834c5bab50"
    sha256 cellar: :any,                 arm64_ventura: "87febda07d382a6a429cf4abf942e0d7655dbdb49fba443fc0b93c834c5bab50"
    sha256 cellar: :any,                 sonoma:        "cee00673788fdfb2d9fcd5c1d2e1df83aaf4d81d8fa0e7a4d383872807b287ca"
    sha256 cellar: :any,                 ventura:       "cee00673788fdfb2d9fcd5c1d2e1df83aaf4d81d8fa0e7a4d383872807b287ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90309540fa5ba68a9c3755111668b208e9694f895b1872f557b1210f82b630d7"
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