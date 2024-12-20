class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https:elixir-lang.org"
  url "https:github.comelixir-langelixirarchiverefstagsv1.18.0.tar.gz"
  sha256 "f29104ae5a0ea78786b5fb96dce0c569db91df5bd1d3472b365dc2ea14ea784f"
  license "Apache-2.0"
  head "https:github.comelixir-langelixir.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43ce252e4ce3834665c7693ea2c4e0be42b003a0ba02e97c365aebd4c9325aa5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1435f0642cbd5a72c57daa56c8e0ed348b5a3f27c3ea33167f75ea795d8cb5d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fd995104718548d93fa40487702de140e615e4d93d4add3efa588bdda06df3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "260ef21bc5a4622277f2299f67bfbab7f183e3f3312d546dc35ca8ed9f008609"
    sha256 cellar: :any_skip_relocation, ventura:       "43c2b39def285ed9d3aa70a905243a3072005d0b6142800cea7cb9f9ac1e9ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2562f1a5ac129e72dec55c6b6c9473bb55c2c2d1a886aaac67ece0a254461b30"
  end

  depends_on "erlang"

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with ErlangOTP \d+)}, shell_output("#{bin}elixir -v"))
  end
end