class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.16.0.tgz"
  sha256 "5208bbde411ac6d7c08d1927c0c330806c1068df92b747daff846d83d7aff325"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ab3be633870b91229938642330dad2c9cbcceb073f95217bafd92a52e1fdc879"
    sha256 cellar: :any, arm64_tahoe:       "ab3be633870b91229938642330dad2c9cbcceb073f95217bafd92a52e1fdc879"
    sha256 cellar: :any, arm64_sequoia:     "ab3be633870b91229938642330dad2c9cbcceb073f95217bafd92a52e1fdc879"
    sha256 cellar: :any, arm64_linux:       "3c256dfa9194c29478588165b51403a03af3eab1d03ed0622df77658e3460851"
    sha256 cellar: :any, x86_64_linux:      "64966ffa5410903e8313d5e18c381b755dce680fd74e4c3d249928a2861844e4"
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