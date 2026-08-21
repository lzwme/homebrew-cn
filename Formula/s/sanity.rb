class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-8.1.0.tgz"
  sha256 "44a2e4cad695f1a4884a7523606687b8bf8cf0af39d73c1887a351dac3a1491b"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2830933515b2be2f42d6f4499c63bc4dbcbe05682fd0cdbb615ad022c4424ea0"
    sha256 cellar: :any, arm64_sequoia: "2830933515b2be2f42d6f4499c63bc4dbcbe05682fd0cdbb615ad022c4424ea0"
    sha256 cellar: :any, arm64_sonoma:  "2830933515b2be2f42d6f4499c63bc4dbcbe05682fd0cdbb615ad022c4424ea0"
    sha256 cellar: :any, sonoma:        "c944b4565cc634373a14f7f136f00d7cea9957cb78b1e7f49218447245e4472e"
    sha256 cellar: :any, arm64_linux:   "63d5bf861fac0cb106126b3623b8e47e81a3dbd870b0852e258946385c280129"
    sha256 cellar: :any, x86_64_linux:  "2ce0600475b52f14550388c459b492bd93a3e70ecd5746a8cc42e70f6bd57782"
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