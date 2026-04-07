class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.21.16.tgz"
  sha256 "07e2d469039df6395569d5f2762a9621f142d86f71810092242753939510e017"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6fd52501f00c01731cfb5384d9b95a78491f6749f54e835b3405849f6776d7f6"
    sha256 cellar: :any,                 arm64_sequoia: "0a94613aa5d5192d7e55e52d17c24ff5b2fabc92473612b7797aaf50b66156e1"
    sha256 cellar: :any,                 arm64_sonoma:  "0a94613aa5d5192d7e55e52d17c24ff5b2fabc92473612b7797aaf50b66156e1"
    sha256 cellar: :any,                 sonoma:        "dce3097b78b7d19431bf29b420cc51450673316486325075542e3cd86d46b0d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef3b0469dcaea835b5230e642ee96c7232ae158da81bcb33e8d972ff0e5a8268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d022cae751ebdb8b0680189372a27fdc8e3cd13694e65577d80afc0f20c4a330"
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