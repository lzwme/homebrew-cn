class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https:erlang-ls.github.io"
  url "https:github.comerlang-lserlang_lsarchiverefstags0.53.0.tar.gz"
  sha256 "e35383dd316af425a950a65d56e7e8179b0d179c3d6473be05306a9b3c0b0ef5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1daae656b510dfc3ce5866c6659555caeda398414583fef40d31592614575f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82d4a67f0748171a2cfffc49fa815679f588ccf09f5753a8444edf75faa3fa43"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82ff31be3e24ecbe8f33130d8bb8689f1a7232132fda5097f301efed6edcf400"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b97ce65d54578a71bf48f9e640a10bddc12b4737657cad05f9272e05809cba4"
    sha256 cellar: :any_skip_relocation, ventura:       "457616735423883340a12c0a6c2a820a459df61de4f2fda81214b29273d504ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "014c2357044609044d5b8048eb5c1c4712fe521490a41ec75592b39cef08b1b9"
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