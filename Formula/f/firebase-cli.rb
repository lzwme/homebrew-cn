class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.30.1.tgz"
  sha256 "ad6f97fde7d32162329f528102caa0c33ff43b517b01e0e4faebd43f69fbb1d3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08be83aefe21d60de3523ddf8e2369545cec4631cf44b38d9380180e3fa1f87e"
    sha256 cellar: :any, arm64_tahoe:       "08be83aefe21d60de3523ddf8e2369545cec4631cf44b38d9380180e3fa1f87e"
    sha256 cellar: :any, arm64_sequoia:     "08be83aefe21d60de3523ddf8e2369545cec4631cf44b38d9380180e3fa1f87e"
    sha256 cellar: :any, arm64_linux:       "1088e6771e0742fd2c6a0546c738ab021ebccafd8a3cff6d1220ec11c486c698"
    sha256 cellar: :any, x86_64_linux:      "53979cf34559bc78a4b0869ae57bc44b8dd07ce7734be01bca63b55f68664836"
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