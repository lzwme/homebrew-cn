class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "f8afb92fe959b42007eeaceb9328cb96cbe095a91510aea15c042c9befbb4b0e"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "119d41bf48e675718af7128fa491d0164c620bec4c125e1eb4a0c692b3f0cd67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "431a872758d3e41fb4e0fddf93ce168413c5daf9e9bcdffaaea7c3894c54130d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d7e04178806a883150f93c8bee52fafbaf1f1be3a5a5791119fac22ca970d7f"
    sha256 cellar: :any,                 arm64_linux:       "0963b90c6d85df5eeb17cafe2e73680de1acca47f8bd2e2bfc6f2c80cb316f08"
    sha256 cellar: :any,                 x86_64_linux:      "957846f77265d812d21a576932208188240d5dc9ce6d5964106fe46ced4dcfed"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end