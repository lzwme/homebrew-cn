class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.3.0.tgz"
  sha256 "11b8b498a473a82429302b7d1438af0ba1d4ea67e63777eb13b548d94dfea9ca"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "531a6987c03cf232b49aa3467b0f392551d20d378e298ad57ba2ebfc1dbdcc50"
    sha256 cellar: :any, arm64_sequoia: "8d387f157b95579c4f07ce554fbd480e992fa77cf0bcee2736e5aca61f0bc281"
    sha256 cellar: :any, arm64_sonoma:  "8d387f157b95579c4f07ce554fbd480e992fa77cf0bcee2736e5aca61f0bc281"
    sha256 cellar: :any, sonoma:        "e32c0b7ed447a2b6f876535c22de87544513fc1775a402041b2c54e378aa5a4f"
    sha256 cellar: :any, arm64_linux:   "4fcdbb8d9993e3be8a82622d62ede7425c7448f8e52ae32f36bfffa31084bfc5"
    sha256 cellar: :any, x86_64_linux:  "0ef159ca820f5346e2589c4461168cc1d92e2a19d6d7f8a4c82606db9ac5bf87"
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