class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.11.0.tgz"
  sha256 "54f5ce9f093a10a900955adba2867268077559ce4c1fa31d5ffbc73e38220892"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a36deecd4cb6023d6d8a49cb75650c03edca7a17f630577dcff38cfed45abc81"
    sha256 cellar: :any, arm64_tahoe:       "a36deecd4cb6023d6d8a49cb75650c03edca7a17f630577dcff38cfed45abc81"
    sha256 cellar: :any, arm64_sequoia:     "a36deecd4cb6023d6d8a49cb75650c03edca7a17f630577dcff38cfed45abc81"
    sha256 cellar: :any, arm64_linux:       "14820996bd81c8e3d7857aa6c64de38923af562292c350a8c49068a1e8d3a205"
    sha256 cellar: :any, x86_64_linux:      "d12f675e26ec165b0defd8c103df9944d6117608cf31d9440d58ffb788e9f9d9"
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