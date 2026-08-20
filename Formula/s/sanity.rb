class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.0.3.tgz"
  sha256 "6f13c47668de4d4e628d783429f499bb56938fc5cf5d4f82497a901acb7ed930"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1362c5443db07ae1de1a864ea006f4e782f9ec45f8f1df5bfd003de0745c7d03"
    sha256 cellar: :any, arm64_sequoia: "1362c5443db07ae1de1a864ea006f4e782f9ec45f8f1df5bfd003de0745c7d03"
    sha256 cellar: :any, arm64_sonoma:  "1362c5443db07ae1de1a864ea006f4e782f9ec45f8f1df5bfd003de0745c7d03"
    sha256 cellar: :any, sonoma:        "19af21ece557cb21562b558fd36bdaed74d51fb584665321cfca0133cb7361e8"
    sha256 cellar: :any, arm64_linux:   "2350fecfc5a010965ded8ab55ce3f925bc534af24589ef4ad0a46acc0ad9f07d"
    sha256 cellar: :any, x86_64_linux:  "36e8bfaebd81e59b7d6b191593dbb4593bf4d3867e4589a497e64ed25fbaa7ad"
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