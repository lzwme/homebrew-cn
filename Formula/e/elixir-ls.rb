class ElixirLs < Formula
  desc "Language Server and Debugger for Elixir"
  homepage "https:elixir-lsp.github.ioelixir-ls"
  url "https:github.comelixir-lspelixir-lsarchiverefstagsv0.21.2.tar.gz"
  sha256 "2621ac4d01531a5cb39ac2ede53b4a50c307753027f636a09dd7e52c1e9aa563"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb6954bae07d0f08e349420039959c22454cfd339732c691a83458696847d018"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5f1c727bbdc78747d3f55e0331c6d438612f3c72072650dd2bd383325cdd13d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e14bf2c91a0c1d32f97c31ac1d7df4ef2c1e44bebf8ac186d6c9ac9a4b2a50e"
    sha256 cellar: :any_skip_relocation, sonoma:         "df13fdd5556974004b4e80ddd2950271e45817293781b7becd1d912b340a9fc3"
    sha256 cellar: :any_skip_relocation, ventura:        "c40fa8590bd2c0beaed760b8a0cb7bdc1d2c7cd6b325caffb74d37d1ac39dbf2"
    sha256 cellar: :any_skip_relocation, monterey:       "d66a9f3a6788630332aa730fee0e6656309e75384a7e908b286808f4c5eb4082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ac3b87a635503d3a9375c55f8436d85a843640524286dcb05c7f16ea8282ba"
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