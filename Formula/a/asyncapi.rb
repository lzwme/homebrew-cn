class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-3.4.1.tgz"
  sha256 "f7188ebb90ca5db13844c9b585ddaee15341736fbc6301fd68c3d9085267800a"
  license "Apache-2.0"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bd13412abd054ea3d45983d2c4b519e25d93881bdb1a314df80a85de7b5521b8"
    sha256 cellar: :any,                 arm64_sonoma:  "bd13412abd054ea3d45983d2c4b519e25d93881bdb1a314df80a85de7b5521b8"
    sha256 cellar: :any,                 arm64_ventura: "bd13412abd054ea3d45983d2c4b519e25d93881bdb1a314df80a85de7b5521b8"
    sha256 cellar: :any,                 sonoma:        "02845505bf8cb43d901984d722caec5038b0accb98a7d7cae6bec01367e13f69"
    sha256 cellar: :any,                 ventura:       "02845505bf8cb43d901984d722caec5038b0accb98a7d7cae6bec01367e13f69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70c6a5e1b505f742acca2d46a6e695bf73d4d12fa3aedff071f876d96811794c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6dace4f0b4ce21af80ea506047d7b24a0d0dbd8babcd2ec6933200469e8ac3d"
  end

  depends_on "node"

  def install
    system "npm", "install", "--ignore-scripts", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Cleanup .pnpm folder
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    rm_r (node_modules/"@asyncapi/studio/build/standalone/node_modules/.pnpm") if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    system bin/"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath/"asyncapi.yml", "AsyncAPI file was not created"
  end
end