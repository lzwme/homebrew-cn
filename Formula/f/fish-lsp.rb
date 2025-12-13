class FishLsp < Formula
  desc "LSP implementation for the fish shell language"
  homepage "https://www.fish-lsp.dev"
  url "https://registry.npmjs.org/fish-lsp/-/fish-lsp-1.1.2.tgz"
  sha256 "8e06bd897f314214dda89241f2c0cb3132b22f8c06ce6c1dbb2b6165846cfc95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a2560f5dc4263f0d473cd1ad9db4bfaf3a9c29a15c920d223d8d22444a1a525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c56a7fefbe1a87e880cf66b4915569cf942b2118209413caef9fe77924f8f404"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b1ab06ab0a04e73cec0a4b628d65dfad216b54bc9403745e064d0189bbf5db5"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91d3c0a44efcaa3a1d222c802b67b266d0c63b763187cfffa0196fcf0686261"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18bf87ec823c6153d0fc0f08e38f45e16f4c0d546303b9e4556cd7767b77cf0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "646ae0cfd96c711c01016be38a18df6d0585354464bcb31f5737be890fce35e0"
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