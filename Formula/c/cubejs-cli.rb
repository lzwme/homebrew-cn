class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-1.6.66.tgz"
  sha256 "6de142b6bbcc2fc2213738d0a29bf5524000c5ea03e25d4db7ba38257877dd39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cafce0628af36437c17c0cc9346e36542509caf83ea4c2a4375eb02bf6ebc1d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75b30df932152ce8f6217e13314af9420b1450246146c8368d07b0737443152e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b30df932152ce8f6217e13314af9420b1450246146c8368d07b0737443152e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f2722cc8741063516d8ed0d21d2da051949b1eb93ba3b7681000a08c37714e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbad363f3667ab52d8fe7fd28d4de9bd7d73fcd666810ed478aa03a0c3706617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbad363f3667ab52d8fe7fd28d4de9bd7d73fcd666810ed478aa03a0c3706617"
  end

  depends_on "node"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/cubejs-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_path_exists testpath/"hello-world/model/cubes/orders.yml"
  end
end