class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.10.0.tgz"
  sha256 "c1d6213c00021f93c3c873451377709c0ccd24ecb3b0522729102164b4481ce0"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2376b84aa11de09953f7de07b801fc49034b2d8dd1a3fc2f6b521b65fa4706e0"
    sha256 cellar: :any, arm64_tahoe:       "2376b84aa11de09953f7de07b801fc49034b2d8dd1a3fc2f6b521b65fa4706e0"
    sha256 cellar: :any, arm64_sequoia:     "2376b84aa11de09953f7de07b801fc49034b2d8dd1a3fc2f6b521b65fa4706e0"
    sha256 cellar: :any, arm64_linux:       "c9f9303b9bdeac36d48d2d30080a0a99bddc051cd10cd301f6f1f23c041c4d2d"
    sha256 cellar: :any, x86_64_linux:      "e5710a55e5879794c7c705b0001b5f04a10db1f25c3c7d33dde2f72a45104fda"
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