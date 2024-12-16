class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https:elixir-lsp.github.ioelixir-ls"
  url "https:github.comelixir-lspelixir-lsarchiverefstagsv0.25.0.tar.gz"
  sha256 "43cc1ee3b99adff6af93d3ad49959041875b8d1eee8cc517b4b1a65d583f857c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b5a8edffec9b191c7e9cc5251824dbca016e9b506d6418c1a13b5b27542b4d7"
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

    output = pipe_output(bin"elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end