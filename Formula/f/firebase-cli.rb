class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.20.0.tgz"
  sha256 "95e89a94cb143361183e5836c428ae999fc046df16c4ff12203e80b2bcfb1f38"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1d5ccce39bacf5fa3010b7770050463a0ada24c146566a86744ef3b25aa5f194"
    sha256 cellar: :any, arm64_sequoia: "6d24ce3c13f46c03513da5a88969d2d4be2c7e25be0f58589e46a610b49a14df"
    sha256 cellar: :any, arm64_sonoma:  "6d24ce3c13f46c03513da5a88969d2d4be2c7e25be0f58589e46a610b49a14df"
    sha256 cellar: :any, sonoma:        "864990a1a12e0b5578dd301bbda3958db9f255d24c946925b6be61da0b3e1afb"
    sha256 cellar: :any, arm64_linux:   "ca3ecdd45986291c7016a1613f85d4f96b50e5fffb74ecf685013bd600935170"
    sha256 cellar: :any, x86_64_linux:  "d8a4547e19938d7ad75afee08111fa8f2df647278279e1212a9088dae3f04969"
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