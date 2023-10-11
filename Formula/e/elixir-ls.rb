class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https://elixir-lsp.github.io/elixir-ls"
  url "https://ghproxy.com/https://github.com/elixir-lsp/elixir-ls/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "95e937fac2d51979f20b1d4cb0d6781ec244cc6f8221856c451f7bafe0351b68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2982151b57cead95dbe03ca0d7fd8dc8cc3b917fb8cc4ce6f66bbbeecff4c14"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f67a2ecf2e6a5a6c5995eea22550a6d28725a390b385c4a485c729f7f080646"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131ab214ee6abd746e4fedd4bd82fc105e2745908032b3f39905b06297d8e2ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a180b9de6c8e6e512c9409daf371c83beb1c3d3ef2a9ef650d873eff9ef08cd"
    sha256 cellar: :any_skip_relocation, ventura:        "eec67b2a9fba789d341e02d8a797cad2cb86969dd7600fc4191315966506dced"
    sha256 cellar: :any_skip_relocation, monterey:       "d894138d0bd4b175e9ed17e04622c6cf23f59be62bec01519eb2164bc1d8b071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0742992b8112b7939903efb13c48e8f8fbc9b09e1718daaacec64284b5bfed4"
  end

  depends_on "elixir"

  def install
    ENV["MIX_ENV"] = "prod"

    system "mix", "local.hex", "--force"
    system "mix", "local.rebar", "--force"
    system "mix", "deps.get"
    system "mix", "compile"
    system "mix", "elixir_ls.release", "-o", libexec

    bin.install_symlink libexec/"language_server.sh" => "elixir-ls"
  end

  test do
    assert_predicate bin/"elixir-ls", :exist?
    system "mix", "local.hex", "--force"

    input =
      "Content-Length: 152\r\n" \
      "\r\n" \
      "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"initialize\",\"params\":{\"" \
      "processId\":88075,\"rootUri\":null,\"capabilities\":{},\"trace\":\"ver" \
      "bose\",\"workspaceFolders\":null}}\r\n"

    output = pipe_output("#{bin}/elixir-ls", input, 0)
    assert_match "Content-Length", output
  end
end