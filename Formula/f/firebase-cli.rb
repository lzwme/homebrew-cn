class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.16.0.tgz"
  sha256 "6f02af660b1d8c80b28b472b02603d6ec273dcc047ee8c8128aadc5464061354"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c57522029d0f034cdada8af68e02e0630f6f9677251cd6333dd497fd06cf509"
    sha256 cellar: :any,                 arm64_sequoia: "a80a4a2479ecbd3ef33c63f92a38911da37cdfbdd95731f70e49fa33746f4af9"
    sha256 cellar: :any,                 arm64_sonoma:  "a80a4a2479ecbd3ef33c63f92a38911da37cdfbdd95731f70e49fa33746f4af9"
    sha256 cellar: :any,                 sonoma:        "2ccbcc0b77a4f4881f841ed860b674e05fc52ca3d84fceea0cebc7392ac8a7d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56cbc9df0e9ae8f507e7d28de24f3647dbb5b190f0ac70e9a03906462d43c3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdfbf45cd9b63da96932f023c8c3eea3acf98088ce1a9d4d7f0b4e4dfcf2dc29"
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