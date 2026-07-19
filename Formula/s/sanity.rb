class Sanity < Formula
  desc "Command-line interface for Sanity"
  homepage "https://www.sanity.io/"
  url "https://registry.npmjs.org/@sanity/cli/-/cli-7.10.0.tgz"
  sha256 "d9d4219baa0dfa4fe70e855ea3c1585d050a1271a75feedd87ff0199f885db4c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9d5cffb36b9cad4c115f24e20bcc53013f8ec64759c6f88299a79d6a9f52f82"
    sha256 cellar: :any, arm64_sequoia: "d9d5cffb36b9cad4c115f24e20bcc53013f8ec64759c6f88299a79d6a9f52f82"
    sha256 cellar: :any, arm64_sonoma:  "d9d5cffb36b9cad4c115f24e20bcc53013f8ec64759c6f88299a79d6a9f52f82"
    sha256 cellar: :any, sonoma:        "76591141e88fab436fd8c71cc2aa5f0ca3feae7f6b71430dfb30325a707b1a7b"
    sha256 cellar: :any, arm64_linux:   "e242e01e37c42bd16693eb4c39cdec7603c0a8987b30b40cc0656a626eaa219a"
    sha256 cellar: :any, x86_64_linux:  "bbe0354e16497a993a730efde3f582a6d02356c89ecb61b992bd2cd0920a5d7f"
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