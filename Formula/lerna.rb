require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.1.4.tgz"
  sha256 "0b04cf0e38b3a4eedf7a708fa2a2261e293ef9dae90194fe925ae99ff7687429"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "860e158dffdd51a4f14e2f045e6fc4061ff1b558060bce8f7ff3ef9ecc515ef3"
    sha256                               arm64_monterey: "e4e28275ee5f6f5a0e53798f4084b160525e6a5128f4b8c6da7802afd4fa4f5f"
    sha256                               arm64_big_sur:  "b1ed6304848194e82230e613bd7c435d9c04f8405582d817c51c085ec3769db8"
    sha256                               ventura:        "a79ceb6636126d6b178aaa9c6d0efda5782678f482d2127fe4a8f16a41a72f9f"
    sha256                               monterey:       "ce3c33979683e0722407780bb98f5a7b41380804b2d1ad1fbea0ebb351b0c63a"
    sha256                               big_sur:        "989c37fbd56af6bb80070f15e6caea8cc9eb1fd0728da3a089188a657ffaa198"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d17c10a7b1edd020b8608c30dcf83be29843ea8b11609c1423e67ff7239dc71"
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