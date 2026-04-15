class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.1.tgz"
  sha256 "d1219980596d08bb82f53c93734b13957b8c69defa262d1f3734b2511ad7c8b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "374ae71d814e5a2e024262c77c81eebc34888c4e2a98a721b347f8ed489f2627"
    sha256 cellar: :any,                 arm64_sequoia: "8fbcef2be552665a2213a8bc826807ec53e63178f40a172a41b7d70da6c526ae"
    sha256 cellar: :any,                 arm64_sonoma:  "8fbcef2be552665a2213a8bc826807ec53e63178f40a172a41b7d70da6c526ae"
    sha256 cellar: :any,                 sonoma:        "18a13784e35952faad8b09776ce420a030fbd42032a2e9aefc9d34a723d695fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1f1e775e3c4bfd3bcd9bf51f4e0113477fe6b355edf1238ef777f8f0ff59083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0de514baa8b0fe51a835d5c76d5ff252e52196d6c95a7e0297bc85273a7f9094"
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