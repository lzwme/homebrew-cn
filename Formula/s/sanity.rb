class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.2.1.tgz"
  sha256 "1f6469fcd6755b0617745688782e6caa4c05b05626cb6abd82a8694e82378d4e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5cecfd60fd9b15d866181f731de8ee116c51707f7bd0714004802763f10ad4af"
    sha256 cellar: :any, arm64_sequoia: "9ce2e65429144a746f66cf93137c2c7359039ebc8ba8a005c9e204c83a8e589b"
    sha256 cellar: :any, arm64_sonoma:  "9ce2e65429144a746f66cf93137c2c7359039ebc8ba8a005c9e204c83a8e589b"
    sha256 cellar: :any, sonoma:        "79aed4137093e4a2523756a46cd202ff21019d41b4cb281540b2e99703fc3dd2"
    sha256 cellar: :any, arm64_linux:   "e3ecd51fb0c01b61c9434cac09138ece9a15789995e25c502dc04dc70ade4707"
    sha256 cellar: :any, x86_64_linux:  "213a5133d80e53bd3ab1e7714328917c6bb7880861b0be799e865ab22d5f5938"
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