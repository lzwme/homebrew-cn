class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.27.0.tgz"
  sha256 "642589983d0f655c9726ed38b2a538af9956460d5610c87f655a785bf572c72d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dc5554c79f56d5e29a491f76e09769b25a66b4b127f52a20425c5caad6257b55"
    sha256 cellar: :any, arm64_sequoia: "dc5554c79f56d5e29a491f76e09769b25a66b4b127f52a20425c5caad6257b55"
    sha256 cellar: :any, arm64_sonoma:  "dc5554c79f56d5e29a491f76e09769b25a66b4b127f52a20425c5caad6257b55"
    sha256 cellar: :any, sonoma:        "bd522b806986ad99199dab673450c96d1cf5dc8f363a71b96df1985bf8857661"
    sha256 cellar: :any, arm64_linux:   "a2f1f34c88bc50e6648ea02d273de4778ab7a314e9fab5c81bdbea95b4102c7a"
    sha256 cellar: :any, x86_64_linux:  "0301d6ba98e134244aeb907f906deee3a94a2e7f9c8426b902e0aaf5e09f7055"
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