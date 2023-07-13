require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.1.3.tgz"
  sha256 "298020ec4f51d8c77218465f25b90791b987c28272dee09e17b973caf84b313a"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "60a9cfce0d38df053ba8ada5d6bef40a901752ec61834c479f0d916604dde068"
    sha256                               arm64_monterey: "71d5d3418ab5bf6cee7d53b6edff50eb3948799894648f491b5017274a4d203f"
    sha256                               arm64_big_sur:  "81dfbe3ffc0cf5cb5ab47258c6b0b1e6880eba232b0c0de02836403c7c75a22f"
    sha256                               ventura:        "24a89f59c23af78c0285d9371db7a32ec60fe1716eda1ba35b84e5b66983d3ae"
    sha256                               monterey:       "8a51056d58abd7fb104367b08756ceb045a15f34da159d99b3dcbe5225bbace9"
    sha256                               big_sur:        "68a7577498880a523cc0c35aa358822bb82a31c89c4a1b0cbf251deb914002ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15d6448f6a3539b8225f01890437667b4c6da1e3dbd464089d8b73f6fa1b6c58"
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