class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-15.33.0.tgz"
  sha256 "c03911a30482eac34da1f9d12379a2fa13ba3aaaac66fbbff452c62f20440505"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a14521a51b32db2b6d815657d96dde1d9bd59a8a58d9f1a31b1d7839964be498"
    sha256 cellar: :any, arm64_tahoe:       "a14521a51b32db2b6d815657d96dde1d9bd59a8a58d9f1a31b1d7839964be498"
    sha256 cellar: :any, arm64_sequoia:     "a14521a51b32db2b6d815657d96dde1d9bd59a8a58d9f1a31b1d7839964be498"
    sha256 cellar: :any, arm64_linux:       "a3430a6c7a7ea4c98cd396a17a7317a590b88d1af6d8676bd6630beb37cb4e49"
    sha256 cellar: :any, x86_64_linux:      "0438712153708b1ff96e13729d3804a86e5ce5f8b9d883a48a7076aeedba2461"
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