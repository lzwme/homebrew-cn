class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https:erlang-ls.github.io"
  url "https:github.comerlang-lserlang_lsarchiverefstags0.53.0.tar.gz"
  sha256 "e35383dd316af425a950a65d56e7e8179b0d179c3d6473be05306a9b3c0b0ef5"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c29526bbfe1346a66184bf374fba51e3e083bb311445aa9f1c078e6dabac7151"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ada77a1615752881d5632cefc36b9f06c1bed8ee4f990d9ac8e64a7086ceb644"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "706d5776200376589006984147ec10b73030740cc8ebb46c45e1d826cc113856"
    sha256 cellar: :any_skip_relocation, sonoma:        "0240ba4ac93d48f3c18cfa706323067f2df880675560ed461db9c2f2bfc9fb2c"
    sha256 cellar: :any_skip_relocation, ventura:       "bee4af0a940d8466677c241bf50d7f06f0c3c9f878b3feddb8301b1e10971fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a20377b55bff8fa003408fa66bb344cfd6a48c8d0f054b1a99698e83fd589643"
  end

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output(bin"erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end