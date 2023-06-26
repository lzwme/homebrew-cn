require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.1.0.tgz"
  sha256 "0df9df3646c9c7c90dbec69db55a65f210d97e38d4d71a3fd5170c0b6df3152f"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "de23e77098482041b267a459bf63befcb708fc9b9435e50b1d01dbb1ec82768b"
    sha256                               arm64_monterey: "985fe671b981dd882aeb3be5c2d1368306a1dddd976a6366fcea828c6cfed36a"
    sha256                               arm64_big_sur:  "86782ff5e8a25ca7016f1ba03bfc4a2469958fe6fdae0b71b215786313881269"
    sha256                               ventura:        "b58bc361acd4afc486413bb6c80fa641cb951e379ecee58eb9bf72e91a8b8a99"
    sha256                               monterey:       "4321d530c48c81764b77d869c949d8977633d53c69f90fbe8273b2affacda9be"
    sha256                               big_sur:        "0eaaf67487b217647f68068eba0630b783e5e4eecde06c68fad12a685ef67f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7929fae82fda280508c8a5aae4334974cb32718732c8adb3286253e1075e89ba"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/lerna/node_modules"
    (node_modules/"@parcel/watcher/prebuilds/linux-x64/node.napi.musl.node").unlink
    (node_modules/"@nx/nx-linux-x64-musl/nx.linux-x64-musl.node").unlink if OS.linux?
    (node_modules/"@parcel/watcher/prebuilds").each_child { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end