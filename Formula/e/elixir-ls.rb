class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https:elixir-lsp.github.ioelixir-ls"
  url "https:github.comelixir-lspelixir-lsarchiverefstagsv0.22.1.tar.gz"
  sha256 "adfa1d0f1af73cced9cb38a3518644a2eace830e0ed79648043fffb6da81f190"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f33b9a5b244c37599c7c6bc88789b5a1bbdb2ebd6b7fafbda280b6e8862585df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33b9a5b244c37599c7c6bc88789b5a1bbdb2ebd6b7fafbda280b6e8862585df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33b9a5b244c37599c7c6bc88789b5a1bbdb2ebd6b7fafbda280b6e8862585df"
    sha256 cellar: :any_skip_relocation, sonoma:         "f33b9a5b244c37599c7c6bc88789b5a1bbdb2ebd6b7fafbda280b6e8862585df"
    sha256 cellar: :any_skip_relocation, ventura:        "f33b9a5b244c37599c7c6bc88789b5a1bbdb2ebd6b7fafbda280b6e8862585df"
    sha256 cellar: :any_skip_relocation, monterey:       "f33b9a5b244c37599c7c6bc88789b5a1bbdb2ebd6b7fafbda280b6e8862585df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdc8f79c6ef5fc9e157a94238661c089e463e0f22c0264b05610603ba1b9fc79"
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