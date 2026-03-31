class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.4.tgz"
  sha256 "dd4f238d256c1916fda568562a7af6505e95448179d0dfd339dff5c2b21bb087"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "676845627a0fca78103d8550cd2dcd77d7bf46b54091b07b2db7b6e641ce644e"
    sha256 cellar: :any,                 arm64_sequoia: "b441a9b12d9ee8eb32ac49210743c9cdb74b046c5edebe5e9225e2028dccb3eb"
    sha256 cellar: :any,                 arm64_sonoma:  "b441a9b12d9ee8eb32ac49210743c9cdb74b046c5edebe5e9225e2028dccb3eb"
    sha256 cellar: :any,                 sonoma:        "5e22e22ad2e5e4a9d7e3f71906a5ca5753cdb5ae39b9a8aec020aefdb2cd94d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ae324d16b86c7de110caf4dd528434bc88d14a58060b16c6f192f48371ce7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "872a702f12451408b6d42ec875a6a167a4dbc692ea16cf91980bfdb284596afc"
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