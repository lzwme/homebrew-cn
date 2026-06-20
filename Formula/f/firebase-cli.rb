class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.22.0.tgz"
  sha256 "65af869807bf03d8fe2c30de78a85ffb10d781379b45034614abf92adbe93798"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57fec658d8af545127c41b1448688b11f29e75cc8adb35b701314115ed901149"
    sha256 cellar: :any, arm64_sequoia: "3b95973e8303290e7d19e4f7a5a7fbb60dd39c8bd007da86de540467338b2235"
    sha256 cellar: :any, arm64_sonoma:  "3b95973e8303290e7d19e4f7a5a7fbb60dd39c8bd007da86de540467338b2235"
    sha256 cellar: :any, sonoma:        "efc5a308d13989fbb8b06470480f2879b20a2967caf7f626a278ac8b84e730b7"
    sha256 cellar: :any, arm64_linux:   "f07bf42c918b3c02432d2797d2bec61efb28cc7f827c0b40523cee7a96841296"
    sha256 cellar: :any, x86_64_linux:  "f0b6dd942a184e6ef337f969886f43d1cf9d8253497d6d3cf613241e2101c38c"
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