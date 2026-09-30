class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.32.0.tgz"
  sha256 "bbed008bb9d5c6e71805e96dfd1edf5b1c903602f911550cd04dfa506aa9eaf5"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "08da5d1b09e546aa8a5ac1e7ab9e85b6d3a867d50020b234dc8f42aeccc7fd60"
    sha256 cellar: :any, arm64_tahoe:       "08da5d1b09e546aa8a5ac1e7ab9e85b6d3a867d50020b234dc8f42aeccc7fd60"
    sha256 cellar: :any, arm64_sequoia:     "08da5d1b09e546aa8a5ac1e7ab9e85b6d3a867d50020b234dc8f42aeccc7fd60"
    sha256 cellar: :any, arm64_linux:       "d5dc66c18ae0f8a58d269196d9689795904c0b694c9b5d2f7d885fa93148ca53"
    sha256 cellar: :any, x86_64_linux:      "e80775dc65d6dbf9e9cf0efe092fc083986b74d51f91b7b054a17bd14f8fbd2e"
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