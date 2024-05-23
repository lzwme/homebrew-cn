class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https:elixir-lsp.github.ioelixir-ls"
  url "https:github.comelixir-lspelixir-lsarchiverefstagsv0.21.3.tar.gz"
  sha256 "81a97816533910de5b8a4a7d73f597b6429af29001e2f931f1bbb147e8ca6593"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfc8caf91f8cea19af78147e6d3dc68819de9f33452d5acd07e4848235b87f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cdc15a5fd367f93f49eb762ab80baf33f5fdaccb19fb5f0601556a0c08f9656"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6d75d16c077a2c284069acc8057daeb64fd23e22abc353d725fbd17b614645e"
    sha256 cellar: :any_skip_relocation, sonoma:         "413f250f1ab8420c7db4a7d40d85baf1fffb3ef118b017ee0c18536fdf63c493"
    sha256 cellar: :any_skip_relocation, ventura:        "5004d51a7351c769cd75aecb95e9c7e1af6fd8ee66a6e61e7f2564c633d66c8d"
    sha256 cellar: :any_skip_relocation, monterey:       "029451d721fc3bea9d10ff93a662a223d3bee276c80290e3d4558f790ff8c6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f2291c18703a1323249d8cf647f470efebd80c8e564bc132f17b128eee90769"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release2", "-o", libexec
    libexec.glob("*.bat").map(&:unlink)

    bin.install_symlink libexec"language_server.sh" => "elixir-ls"
  end

  test do
    assert_predicate bin"elixir-ls", :exist?
    system "mix", "local.hex", "--force"

    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end