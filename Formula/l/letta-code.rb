class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.24.7.tgz"
  sha256 "b9a4398503bd90af3f868fdb74c902e12d13fa45fae77e07337f8d90bae10e28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "154bea06883d7a3e476a222683fb3bbbae6e377ebd0ff35c4ae764538665ee43"
    sha256 cellar: :any,                 arm64_sequoia: "086cef0bfaaca55083938d119acd6562d021865912e1f063e0010e6c515fe47d"
    sha256 cellar: :any,                 arm64_sonoma:  "086cef0bfaaca55083938d119acd6562d021865912e1f063e0010e6c515fe47d"
    sha256 cellar: :any,                 sonoma:        "71d0e9b48107633a3a324159bd2ef999db6e07736c9facb632a8b8d160fd28f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed8721d93bc0ae9b5a449335a3580563c6829181913dd53579669bbf05701933"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebbbe02a05cd4b75911cd94328385ed934927260409dcaab0182bfef2d964118"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/@letta-ai/letta-code/node_modules"
    (node_modules/"node-pty/prebuilds").glob("*").each do |dir|
      rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end