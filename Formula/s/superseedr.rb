class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "eea522d2397c989b7c56142ad113f3d9f899a37cf1850a0c611e298ba71a0a24"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "772537b87aa22d0d7b216ebb1978fc579a38e21c9e9a0b6497aaf77c68b0bdb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4bd0bdde938c7ab2f3e95f5866b640912400b5ccdcc3e1e6bf20f41b74de79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ff847b24f5493ec8afa60b256fe55f2427ed8912889105c3682e83a0a3ee251"
    sha256 cellar: :any_skip_relocation, sonoma:        "59ae0f161a9517f832c66a7cb0322dadb7ed7ab38d5dc81c88a31ac88d139459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2d57c7aa54a8efc2695930ac58f3c684fca70a0b5d04f411b414f4d182c7ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a72ac1aff0f6e8671355eb327171173524a566a051826903d024f888c0d7ac65"
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