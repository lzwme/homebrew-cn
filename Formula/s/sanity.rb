class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-6.7.1.tgz"
  sha256 "b6a59e4c248f80b3ed8f4e922a4150d89695a33754d314d20b1f67c7895ec6ac"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea7512d4cd8a237c053d6c39a2cf597c60d6587f06426a9390934186516bd087"
    sha256 cellar: :any, arm64_sequoia: "a5299bdc99172dd27d106dabc13c5f5f6f0e882fc376460fec35952217e8af71"
    sha256 cellar: :any, arm64_sonoma:  "a5299bdc99172dd27d106dabc13c5f5f6f0e882fc376460fec35952217e8af71"
    sha256 cellar: :any, sonoma:        "5ad164961c4d0c3f9bd787190437976738db8ef28464082316fb86f72ef2a4f7"
    sha256 cellar: :any, arm64_linux:   "655c88e71328eb970351d37178667db2eff4a2e2dfae6499835b24c7dac0ab79"
    sha256 cellar: :any, x86_64_linux:  "1577806cc326fb887e259e3972a21753dc29124cd02c49eeb80df4d4af6bbb0b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@sanity/cli/node_modules"
    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
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