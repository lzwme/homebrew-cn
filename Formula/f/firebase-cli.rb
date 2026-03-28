class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.12.0.tgz"
  sha256 "b8dc7f6424ec632087e9c1756ce3ee4714a8527b54aabbf3596cb050552f6756"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "30a9d5eb7ed02ded92b6367e1213b54e6bdda657eed62db7a3e520b9317f31b7"
    sha256 cellar: :any,                 arm64_sequoia: "f3b37bc5e505a263bf83fb404c1c923ca639a5013fd9428a1bc8d4bb4e5c4cba"
    sha256 cellar: :any,                 arm64_sonoma:  "f3b37bc5e505a263bf83fb404c1c923ca639a5013fd9428a1bc8d4bb4e5c4cba"
    sha256 cellar: :any,                 sonoma:        "ca14731c9b2e085e0e4b8cf21e804ecc8f0875615000f74d9135610389f3a884"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f622fd43fb348f0af57a24f11e14462289d35d15e0f8e1cb31642562f4c1c64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43818bbc5bbc4873b42198ce5efd72eccd1f33c34d0260de3dc32597ac304d3d"
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