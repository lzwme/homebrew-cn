class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.13.1.tgz"
  sha256 "f025bae184214b7747a09aa72f6255dc8ddab2254219d39dbec99d9ca575e2db"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9c62b2400a0291648e3a008fd71a65b273a2b75542eb08a59c9533937270ceba"
    sha256 cellar: :any, arm64_tahoe:       "9c62b2400a0291648e3a008fd71a65b273a2b75542eb08a59c9533937270ceba"
    sha256 cellar: :any, arm64_sequoia:     "9c62b2400a0291648e3a008fd71a65b273a2b75542eb08a59c9533937270ceba"
    sha256 cellar: :any, arm64_linux:       "c95a9f14bf5d6c43dc266f898eed5a71314b9b838b3a488b8c5185975816e30a"
    sha256 cellar: :any, x86_64_linux:      "9b31724185fe0417f74bc9aea122c73bfe353b59f9be8d19811a35a64e65039b"
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