class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.26.0.tgz"
  sha256 "a2d5ff6a10dda17fd5005ee39c7267ec9cbba4f136f8ded07c7133afa08fcbbf"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bf22cbc02adaa52e224aa7c1c19b6e1587188883233c0196570eb9bea8f3c8b1"
    sha256 cellar: :any, arm64_sequoia: "bf22cbc02adaa52e224aa7c1c19b6e1587188883233c0196570eb9bea8f3c8b1"
    sha256 cellar: :any, arm64_sonoma:  "bf22cbc02adaa52e224aa7c1c19b6e1587188883233c0196570eb9bea8f3c8b1"
    sha256 cellar: :any, sonoma:        "730b5d5f48aaf7bc1623cd104d4442ef70b4892766dd653dde36004590e74997"
    sha256 cellar: :any, arm64_linux:   "914471732223dc690be6fdeafc29af9f41754f6fdc44ac4aa24a0e46e533c6d8"
    sha256 cellar: :any, x86_64_linux:  "b839b65ec0505ee34028a062d15a5c14731b82bc82ed6fa5d2526efabff6624b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end