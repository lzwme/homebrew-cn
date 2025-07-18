class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.3.39.tgz"
  sha256 "ca3168a8f5b5fdb1c864fd972fad0c00283d6ef2168b92b43728f802532fe96f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "384de44612f9b6090b6da1d652482aa4ce2d45f1459f4f158a46bb022cc78518"
    sha256 cellar: :any,                 arm64_sonoma:  "384de44612f9b6090b6da1d652482aa4ce2d45f1459f4f158a46bb022cc78518"
    sha256 cellar: :any,                 arm64_ventura: "384de44612f9b6090b6da1d652482aa4ce2d45f1459f4f158a46bb022cc78518"
    sha256 cellar: :any,                 sonoma:        "477640fe2d1cbfe3094ee15eb05eef27325c84defe4fba624406c635f946e899"
    sha256 cellar: :any,                 ventura:       "477640fe2d1cbfe3094ee15eb05eef27325c84defe4fba624406c635f946e899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ebef7059026b052900b4217b4a3f78826bd62d13683741e1273fca74563349e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ac31ad512370facd39ed47bfb78bb2e5d37687767532340fbe6e414fd30ed9c"
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