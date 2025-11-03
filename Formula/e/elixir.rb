class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://ghfast.top/https://github.com/elixir-lang/elixir/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "3bb6ceadf0174ece79649743bccf208e9708c5a9e1570228ff25c8f7347a2209"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2abede58e188eb5bc67f591e868862151aad247d90383adac004a38ad1f2d5c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbe4843ffba09de86f69aede39f3a7cc93c2a85e05b293cf933244c2e1b256e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00d1dffc00881d572ed491176fc1fa1426d6bc594d3015ce338bacd53807821f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a0890c6dcd37f74cc801fc65db2eb7b8331b53d2a0f34aae1c9a6516e36089b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "941644ee1a606a5b022e4691eff0bf259d3156dfb3b6733c92707be6a4de8767"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baa2759ca860c403312bc6f6e067d028e5db76215299e50bdd51c355b7effeb4"
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