class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://ghfast.top/https://github.com/elixir-lang/elixir/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "4dfbfa2d0863bb3809109757a599b453e78ea890f31fa54456a2d81b40bc930f"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfd19b792bdf2673b54a4afe546416434abcd49d299355c575a5d2011cc23b5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9704cf067a7fb026862fb8f55cdb672f3fc0d3f15c90baa0b413752109402ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f5e65db21a361ae5799ed944df71eab3d649984e2ede84965280949e4bcb17f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c22c3460c240221e0b3cb8f6240ba470a6b26b2e49ac7c450a1c48adf307631f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e3593a9ec4a7f3ac9924d6a5fb1662142f70417fc041c93c45c5d5568faa74e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0964f107a1b05d30914cb799a7e4361b9dd1ca9849bc843aaace165250497af"
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