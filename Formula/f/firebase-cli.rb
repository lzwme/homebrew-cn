class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.34.2.tgz"
  sha256 "55182615d351ec57fd23eb5f7ff0817af30fb63c8c19d212b25fa2e44d1a1be5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ccc201ca7e51890e21edd73d6b1683ad251ee155c7627555d7e602607731b4d5"
    sha256 cellar: :any, arm64_tahoe:       "ccc201ca7e51890e21edd73d6b1683ad251ee155c7627555d7e602607731b4d5"
    sha256 cellar: :any, arm64_sequoia:     "ccc201ca7e51890e21edd73d6b1683ad251ee155c7627555d7e602607731b4d5"
    sha256 cellar: :any, arm64_linux:       "27a63141660b9fb42d6fc6a0e38026498e76d0d09cbd2617842554b837d0b55f"
    sha256 cellar: :any, x86_64_linux:      "dce9a3e50e98681a84689c6924f7ca46e55550a6fd88bb387886c90e00e8846c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"

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