class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.32.1.tgz"
  sha256 "afcb5f64447e29692d51ba15c1c85b6cff2f84955f971eeee2f514a1efd64326"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1298239e352027e92b23bc504d931b2693473a880e17316c16117de8c564f184"
    sha256 cellar: :any, arm64_tahoe:       "1298239e352027e92b23bc504d931b2693473a880e17316c16117de8c564f184"
    sha256 cellar: :any, arm64_sequoia:     "1298239e352027e92b23bc504d931b2693473a880e17316c16117de8c564f184"
    sha256 cellar: :any, arm64_linux:       "d0a854b98e94a676a690280c90d96572549cfd4511051de28107a7d6419dc760"
    sha256 cellar: :any, x86_64_linux:      "debbbf9668636f96d8985c47fb49a4094ca6241deb84ef1d4564a9fbbb159680"
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