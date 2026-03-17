class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.10.1.tgz"
  sha256 "a2c791f82ea064591688ba9b7489b722a14226531a88a4b9915b5e93b814fe8e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82a47c1dd187c40e1aa7285200f002f22560259ae48fb62d100031cbf71c7185"
    sha256 cellar: :any,                 arm64_sequoia: "00c2f17e594e0e386f90d828256a51aa55e1ab4ef760c77f06d59faebd50eb66"
    sha256 cellar: :any,                 arm64_sonoma:  "00c2f17e594e0e386f90d828256a51aa55e1ab4ef760c77f06d59faebd50eb66"
    sha256 cellar: :any,                 sonoma:        "73d97cee26d555ab9e20b1bc3bbc2332c249104445c76e144f4949c4b9c6790d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f05648ac3414bea171bb3745fa151e562c629c7e59d86bcb03f870f101cfd1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566e6579d468ddfce911a2ec4f325d6229ff08c1fae898c127c87ba02cbf0f43"
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