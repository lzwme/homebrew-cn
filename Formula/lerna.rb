require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-7.0.0.tgz"
  sha256 "185931f7fbef218f645d5a44ae23934b2a683738962109856db748d329c580e6"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "d96b0291ad3bc88634f155b97b49b7a05dff7741005d37fa156c7a75a644a9e4"
    sha256                               arm64_monterey: "c499e18d43cb0bd5691d91448616c3872cfc4a0586ef68089be794776a5603d2"
    sha256                               arm64_big_sur:  "6ca043f9eb54c709ccbf7f81bdc8bc8536385ea16d9321994e4fec61b149080f"
    sha256                               ventura:        "e6d6cebb69c70089c0edd319fee7ac943770d4818815200cce1f4bb557672def"
    sha256                               monterey:       "f81c2056619227512da0351454712612af4e0916ea1ede66729fea7165408921"
    sha256                               big_sur:        "4b85d7696b5549bf73146e2ad6ca73c491b61ae09e8fd0660e3244c4ecf463b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d85b64d7fc7c8fe891489b20aa9cdb4d8ae1de7f5466ccc63b86c79fcfdfae5"
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