class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.13.0.tgz"
  sha256 "1f4e30cf70545acb829ca0d71fee415cdd253bbd07db73c2ab0feecba8890c84"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1b3555ebbe3f498b76c8dc1a92fb8801fed88f56c9abd65bffc401a68ad2ecf7"
    sha256 cellar: :any, arm64_tahoe:       "1b3555ebbe3f498b76c8dc1a92fb8801fed88f56c9abd65bffc401a68ad2ecf7"
    sha256 cellar: :any, arm64_sequoia:     "1b3555ebbe3f498b76c8dc1a92fb8801fed88f56c9abd65bffc401a68ad2ecf7"
    sha256 cellar: :any, arm64_linux:       "283f8f581cf81ee0090c5bc2e8c2a00f6ea6a5a29c51ed47004cc5949d8bf079"
    sha256 cellar: :any, x86_64_linux:      "c47eb6611e5ef03ab05c7f8f2342b08153bb11b218b58d21846b1dc4a0c1efec"
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