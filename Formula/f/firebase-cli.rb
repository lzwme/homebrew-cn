class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.9.1.tgz"
  sha256 "3b814f6ec13b7f2e866eb57d64ad15e98fa7e5586013bcb9f03c6443e6e73d50"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e4a42493226792eaf9e0976012276f4077bbc9afb80706907798240ece45cd8"
    sha256 cellar: :any,                 arm64_sequoia: "6eb19d78b8aded874e0e4ca089a6fabb5bd5e3cf6e25173da451a0d2af90a6ce"
    sha256 cellar: :any,                 arm64_sonoma:  "6eb19d78b8aded874e0e4ca089a6fabb5bd5e3cf6e25173da451a0d2af90a6ce"
    sha256 cellar: :any,                 sonoma:        "f9f6a45f4ddeb465d26d2d289c4ed4bb08f597ab569d5b7a35c54d861850afc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c965daeb6e262402debeabf42cf289935646e9a3760a6686f9525fc133b99d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "880e82b64c9118c1792d1184fcf85f6032ee73f98f8e6dd38a1f6af23b641416"
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