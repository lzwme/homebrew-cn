class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.34.tar.gz"
  sha256 "efee1ced6e89a33ff2788cb01720c4a395c98fc0c6bd4ac86d0ba8b467149376"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4fc394a98a9499c860c8008417d88d15cec80c1be87e4bd44cd36bd94124f1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cc3b7e257565d5b1652a3b589da91b4bdf5afbe29427727e41d531c6b3153f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80de8ea9aa9b6e2a1370198798456cae2a6b6dc8cd3ceedf9d0b21e3968d0a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a4882bae82285503254b1ffe55cb59ac561b2108c74f93092aacfff6fea800"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f54af270c27e03c6560794d32696b2f227f7c9d66f98ca023d8214c748eedf17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd667f56d0798c04294ddff8159f0ce53e2a40e9ac8a9063fe3ff6ac943f7392"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # superseedr is a TUI application
    assert_match version.to_s, shell_output("#{bin}/superseedr --version")
  end
end