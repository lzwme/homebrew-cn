class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.22.0.tgz"
  sha256 "4b834aae778614668cb4f45e396824cda14f8360fa196d1614ddfb9337ff3b53"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d3e4017ca119192b33561c06ba2634ccbff3ba868cc12e680b80e23a508aaaa0"
    sha256 cellar: :any, arm64_tahoe:       "d3e4017ca119192b33561c06ba2634ccbff3ba868cc12e680b80e23a508aaaa0"
    sha256 cellar: :any, arm64_sequoia:     "d3e4017ca119192b33561c06ba2634ccbff3ba868cc12e680b80e23a508aaaa0"
    sha256 cellar: :any, arm64_linux:       "ce4a87b56c5a062cf877852a8f549c2520bb592d5f38d9b032787c60c1e7222b"
    sha256 cellar: :any, x86_64_linux:      "d18088519f3f422558ab6f68524306353ad917624ef4542b3729bf1c7e4244fa"
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