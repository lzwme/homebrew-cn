class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.30.0.tgz"
  sha256 "251a423232414a4c150522591f48ccfa7418417bf58652555524567ac8e86d0b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82e2ab63bc2f5199c5e2e387d6d0fc5dfb9027b5c4e8570bdab2198f7b9cdf81"
    sha256 cellar: :any, arm64_tahoe:       "82e2ab63bc2f5199c5e2e387d6d0fc5dfb9027b5c4e8570bdab2198f7b9cdf81"
    sha256 cellar: :any, arm64_sequoia:     "82e2ab63bc2f5199c5e2e387d6d0fc5dfb9027b5c4e8570bdab2198f7b9cdf81"
    sha256 cellar: :any, arm64_linux:       "2dc0beae76a87c2f32f06e7e6e5c220cde4fe1872d171589defdf21a75e9742d"
    sha256 cellar: :any, x86_64_linux:      "9d4516b869e1c6b31f4e417893c1c2a776ff6d2870aab83fa06dce7034bf6817"
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