class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https:elixir-lsp.github.ioelixir-ls"
  url "https:github.comelixir-lspelixir-lsarchiverefstagsv0.27.1.tar.gz"
  sha256 "c4b1874d13ddb1ecad60d791160d6cc4fd9dc4450bf83615bc1d53776f8c9360"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79d9861e122670b8b1eddd611f6c66c9b217ab9989cce8a4b15ccd86ff7c2b2f"
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
    assert_path_exists bin"elixir-ls"
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