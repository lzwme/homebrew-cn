class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https:elixir-lsp.github.ioelixir-ls"
  url "https:github.comelixir-lspelixir-lsarchiverefstagsv0.26.3.tar.gz"
  sha256 "972c8fc249b9e4fdcf1891ca960cabff490b4362a37043b8aece0a2513f088f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "671517cd04f08cb77a6920ad0f55b4b9c8090fcd971f492cbd2a8aaccf883036"
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