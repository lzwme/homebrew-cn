class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.10.0.tgz"
  sha256 "40e48273a12903ce4854db76c5b76e503fb06ed587b21cf113a9e5f1ae52d667"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b856b9e85f0c30db20d29489ee4dcf01ae6dbd8c2af4ff043d4fdfa2c4f2bdaf"
    sha256 cellar: :any,                 arm64_sequoia: "5f4a9fec7156df62e886f7074dc8c6ef0b2b616321f02302e0f52d9a0a9d9b73"
    sha256 cellar: :any,                 arm64_sonoma:  "5f4a9fec7156df62e886f7074dc8c6ef0b2b616321f02302e0f52d9a0a9d9b73"
    sha256 cellar: :any,                 sonoma:        "3a4021208fd962065b25f41a651989653717908c8a13d6256f9c58d8484a43d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2079664ee6e155d698fda5aa566012acd7acba2e57e6e75c43d215593a496ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef6e0d892b3e78d63d21eeba8521390a5157d895ce8d4c1d1569b4b3ffe3d21e"
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