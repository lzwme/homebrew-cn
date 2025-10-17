class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://ghfast.top/https://github.com/elixir-lang/elixir/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "99a684045b49f9c5005a1aa8278e1bac8c3769e0a5a13c05ef80b69113029234"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1c4653e800d72dfdf7643bb984b0c29860a58c4140410fe59df54c1cce0a81a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76dddbb3743a13ef3a542b9b5a89b1bbd37eeb8a7f6a9bebd67130807ade98aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ffe12224e55a5a08e17c019e767d95fca3d642003f86e80962f57e3cdde5140"
    sha256 cellar: :any_skip_relocation, sonoma:        "28ec1e97174b9caba010bcd383ab62b6b915f1236446af028c95a7b5ddcceb8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90d126e2f064e288d002e4803d80f49a6994805647d33c01bc8dbd4129f9d181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e47cb4e1fc64c542988823fdc43fbc9d64b6ff623331f833acaf94a863176d2"
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