class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.22.2.tgz"
  sha256 "ff3a71efc9edaa95ab1584e82de67807043c348b8db9c0c52e14877068e3589b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7b744bd964b1062c6dacf096a1d0208550f609435da014f0e07aadd0b75d23c"
    sha256 cellar: :any, arm64_sequoia: "9a2ed8cc4c2e0071e18706faaa67eb6c965eebe0477e08796395fbae3df67404"
    sha256 cellar: :any, arm64_sonoma:  "9a2ed8cc4c2e0071e18706faaa67eb6c965eebe0477e08796395fbae3df67404"
    sha256 cellar: :any, sonoma:        "e707336abe480164e69cde92aa2382db09d5acbfb74fb12a0b21598965e71597"
    sha256 cellar: :any, arm64_linux:   "d85b422f0632b2a780d760e7d2da10fb56989236f3fc4487c39987c1b9090372"
    sha256 cellar: :any, x86_64_linux:  "bde10c14e0102353d8366bed97d62c0185480a836241f5a70fe4972da58a5aaa"
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