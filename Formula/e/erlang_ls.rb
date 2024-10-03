class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https:erlang-ls.github.io"
  url "https:github.comerlang-lserlang_lsarchiverefstags1.0.0.tar.gz"
  sha256 "c2667d98de0e3e9782acdbe916c7f9e3df3c5d5f2d06c170f5185cc79ad9c19f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43e21fe78982c59857f7a093337e413fbb42f7d8bbecc6cd63c1dcbdbfc60f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df079c84a2f39b241607aae37bfe93abf40d44fa0f727534c4d2def606c6bf79"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abc37823c126a4b5b0e3687a83980557e91b302c32a5aaf406a4cf2d64f5c664"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a2cc9ef198d883020c7940d01a9b688c4c778704948eac2e38874c269b37fbe"
    sha256 cellar: :any_skip_relocation, ventura:       "94e80f17f7c07c63bf507a1fa38544f77719ad3ed54ee2905f4e3849d9c24526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eac5c81faa78bab6f8cd767f1cf32c22e7c4cc3ab5e4492a8a3102088a3767b4"
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