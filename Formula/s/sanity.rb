class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.25.0.tgz"
  sha256 "56ec6f89c905d92fc2b50aa4094d357e50387848497c1448a2d78ead73f444f0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4715fcb4f98cf0d4eeb6d14a579a21c2205d8c7cb3a440f1a9a7392425b4a7d9"
    sha256 cellar: :any, arm64_tahoe:       "4715fcb4f98cf0d4eeb6d14a579a21c2205d8c7cb3a440f1a9a7392425b4a7d9"
    sha256 cellar: :any, arm64_sequoia:     "f4b1bbb601ebc312d179e39e876e1d259c74499418b0d125ed95f239e9e689b9"
    sha256 cellar: :any, arm64_linux:       "66d5afc389338e033f7105d95fce7c6bbe3f238f8115dc9178b1575f2034ecfe"
    sha256 cellar: :any, x86_64_linux:      "8bdc444c937df8598ab9a18f1365d3cb60937e8e7a3bf740e2fd8b1872079262"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-path`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-path,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["HOME"] = testpath
    ENV["CI"] = "1"
    ENV.delete "SANITY_AUTH_TOKEN"

    output = shell_output("#{bin}/sanity debug")
    assert_match "Not logged in", output
    assert_match "No project found", output
  end
end