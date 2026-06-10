class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://ghfast.top/https://github.com/elixir-lang/elixir/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "baed8756da722c1b8d71613655c7223ab952051bc391a965cd79e320a93aaf77"
  license "Apache-2.0"
  compatibility_version 3
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "689920df4f1dd9b1b44e256499abd178aa7e132118eb23bb982301b3db9251ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a6bb2575d376ee06da20c14d4379e9a6273e2750c49c383c4460da60b2542c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a882e18eb4132d47f7d96d934c358027fd60d58df01a8c18796d2b64093362c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4096f17dd4a47a23806da39cbd0288c800d58f8ab19df964dd0e1b3c29d8b02e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b4a86f48c68d98b1509d2025425bf45d2b2bfb63064205d4301fb6398e906e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c315926e28272cea56ff675f835cb095390ff69f384f5030fd949454be3fe49f"
  end

  depends_on "erlang"

  def install
    # Set `Q=` for verbose `make` output
    system "make", "Q=", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match(%r{(compiled with Erlang/OTP \d+)}, shell_output("#{bin}/elixir -v"))
  end
end