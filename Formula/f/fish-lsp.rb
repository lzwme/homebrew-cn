class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.1.1.tgz"
  sha256 "8cf14e16170a68bb95ece08c7de3d3f5d7fc93e906ed31ff31422f5d136ac7ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24b6e8313b5cba1c82528316b4952de227b88099dbedc65aa6e1f2f8a415becf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635491635bf5bdb5b955e23a63b2db37d050443ac6011b1946264f878cbe8fcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "635491635bf5bdb5b955e23a63b2db37d050443ac6011b1946264f878cbe8fcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "1069f2d8da6c1e66afa0ad06e135a1999821ef8af9dbd13fe68507323db0e92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "460cb824aa3530382261c31071af777f59f12a487f94b419f974b4b21445cace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ac8504ba6a7eb1edba342d5c4606aed495d2971b75d537ac88886cbaf976cc8"
  end

  depends_on "fish" => [:build, :test]
  depends_on "node"

  def install
    ENV.append "CXXFLAGS", "-std=c++20"

    # tree-sitter<0.22 fails with clang>=18 but is actually unused
    system "npm", "uninstall", "tree-sitter", "--package-lock-only"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    man1.install "man/fish-lsp.1"
    generate_completions_from_executable(bin/"fish-lsp", "complete", shells: [:fish])

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/fish-lsp/node_modules/tree-sitter/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/fish-lsp start", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end