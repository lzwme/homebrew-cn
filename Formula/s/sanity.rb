class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.20.0.tgz"
  sha256 "f2eb77309e8df09f13c33f06f0ac64b2afda0a2ae7470ec42a6633b0cfa6b6bb"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b2fb2d7670469e82d8532f8a40116e73df5890df3d44dd424a51943394e56d4e"
    sha256 cellar: :any, arm64_tahoe:       "b2fb2d7670469e82d8532f8a40116e73df5890df3d44dd424a51943394e56d4e"
    sha256 cellar: :any, arm64_sequoia:     "b2fb2d7670469e82d8532f8a40116e73df5890df3d44dd424a51943394e56d4e"
    sha256 cellar: :any, arm64_linux:       "a77a75323791b0bb012f7b991e0418ff217caee00b0db164401f1a6c4a5712b8"
    sha256 cellar: :any, x86_64_linux:      "ee512e2a445b928f52d8fd63148b3c32d403723d8ca2d97c36d34d3df545171c"
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