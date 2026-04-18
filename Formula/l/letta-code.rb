class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.23.5.tgz"
  sha256 "8b342ac8a818523bbacdac3ada30ae12d9d1593cd6a7c4a745a4036cde138214"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82a7487265348af00ada77414a3ba34e13a338fa3ee64168f18caffca1c715b2"
    sha256 cellar: :any,                 arm64_sequoia: "0c1986c847e1e0cbaa527bd0c412572316e348fd8ef867ab45cc0e0b77d15319"
    sha256 cellar: :any,                 arm64_sonoma:  "0c1986c847e1e0cbaa527bd0c412572316e348fd8ef867ab45cc0e0b77d15319"
    sha256 cellar: :any,                 sonoma:        "8e94e646a32a396f48dc00d3c652e0cdd864d11da81061b88f656d8ed82924b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0973e7054b1dc42347c4d5bf0f2425e81cb02e8815f60577700fec0688bfd902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7dc9c1d0028dd19191b75798cb87622bf7aa568ffa5146df601267e86ef2e4d"
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