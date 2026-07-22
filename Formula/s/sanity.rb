class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.11.0.tgz"
  sha256 "4bd1438f8eba02c469db3b5608c18f6f9e2d35cbb18d50356c6c4d4e65934d29"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "070ec612d7e0f6b889d0dadc4ef3dfffa62d227a5e2f810e2ca2f727f489cd96"
    sha256 cellar: :any, arm64_sequoia: "070ec612d7e0f6b889d0dadc4ef3dfffa62d227a5e2f810e2ca2f727f489cd96"
    sha256 cellar: :any, arm64_sonoma:  "070ec612d7e0f6b889d0dadc4ef3dfffa62d227a5e2f810e2ca2f727f489cd96"
    sha256 cellar: :any, sonoma:        "d27ef229bafd8cb4a614c531af19f56cf6e74c594e1eccf83043975214030aa8"
    sha256 cellar: :any, arm64_linux:   "8338a6f5c022e2fae1c8206dab3722f65980ccb9abdf699ae8594eb828a56f21"
    sha256 cellar: :any, x86_64_linux:  "087bdb706c60f1f98b0cebbe9097d08d23fd2fe3fd8c7f270553c02a83c04311"
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