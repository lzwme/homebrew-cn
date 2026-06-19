class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.21.0.tgz"
  sha256 "778f28e59d624ea04118816882acae103f8a09470534d64deaa9059744f89efd"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd629f21f138c8046195c171fe38361c52f23fd70f51b72344927e5f40c890dc"
    sha256 cellar: :any, arm64_sequoia: "fb84bd304639437ec502b2dc23f678f1d26c1c21cf13780f2d9501facaaa680b"
    sha256 cellar: :any, arm64_sonoma:  "fb84bd304639437ec502b2dc23f678f1d26c1c21cf13780f2d9501facaaa680b"
    sha256 cellar: :any, sonoma:        "9741e10b9127b2ce42ba71036d92e1eeafee5beb3e0e97b7dcd4460e4922e073"
    sha256 cellar: :any, arm64_linux:   "c6232b17960b64626ace0acae2596c81bba125a745b8ace1e143541834f577a6"
    sha256 cellar: :any, x86_64_linux:  "1e886e47d28ae7fc939ed62bcec84782476b55ab80d7788ae96d88014092d897"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/firebase-tools/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end