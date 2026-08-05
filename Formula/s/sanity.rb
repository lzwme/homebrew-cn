class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.16.0.tgz"
  sha256 "32d1fe4ea094c5d1ea3dd5d1dd55cdeebb361fe53a7cc6979799633b9cc7aeb8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ca931dff666d0e12ddd817eece634c7e085b66d1781a4c56c5c4eaaa8bffd14b"
    sha256 cellar: :any, arm64_sequoia: "ca931dff666d0e12ddd817eece634c7e085b66d1781a4c56c5c4eaaa8bffd14b"
    sha256 cellar: :any, arm64_sonoma:  "ca931dff666d0e12ddd817eece634c7e085b66d1781a4c56c5c4eaaa8bffd14b"
    sha256 cellar: :any, sonoma:        "e0aaa4bf9b502b99179e6cb9c7546f16aa3ab18e5282ee8ab0df2136dc9096e9"
    sha256 cellar: :any, arm64_linux:   "1734cdb42d4469a05367359ef15b0e9fa57ccf28071825aab76d19a082b89f3a"
    sha256 cellar: :any, x86_64_linux:  "1808673e8abf03f73f7cc0183b549f5579730553e82c2bff40b4efe2005f944c"
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