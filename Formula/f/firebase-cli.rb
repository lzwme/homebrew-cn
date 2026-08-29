class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.28.2.tgz"
  sha256 "200d7ff9fdeb1b88446386b1b0f3d0b5d0739920e11ac0b5fdbcb13a42576b7d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "296abd77a9aacc595fc1de07c333b4be54089be3f7019dc0af4e735cc9c4c26f"
    sha256 cellar: :any, arm64_sequoia: "296abd77a9aacc595fc1de07c333b4be54089be3f7019dc0af4e735cc9c4c26f"
    sha256 cellar: :any, arm64_sonoma:  "296abd77a9aacc595fc1de07c333b4be54089be3f7019dc0af4e735cc9c4c26f"
    sha256 cellar: :any, arm64_linux:   "0e6409104bf7cf81e9ea8a198d33cf47b06c3d1a44aec3ef4b2858ee39e5ca49"
    sha256 cellar: :any, x86_64_linux:  "78457682b1d4ae6b19f837f23a39844f80d1ef36a53d7a296cbb3d8cafd62422"
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