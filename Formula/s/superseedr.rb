class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.29.tar.gz"
  sha256 "b895f5354f277bca46ffa03af712ae545611f742250bc4753bbc8f42a9dca21e"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e427f53ad32344829432e486ec281d9254011c7c1b22079351c6df174bc3678f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c94bec07f5710ad26170746581797d46400e0c91d96b4b9c783285c7354e1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ce35864afb9bea221931bb043fded2c5f6031bc5cd3dc7e21c338fdc360b62"
    sha256 cellar: :any_skip_relocation, sonoma:        "a10a1c2bca4ffc8cf065f04bdd728d8ebcb62699e414b55e3f21f882db193fa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c54ffd817599933f3cc4ee0abc4bac8ae07b6c2a337a496aea8f80eeffb7695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc68b417a4fe4a00ada07208454c36828a8a008bdb5157106da6a57c01f86c00"
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