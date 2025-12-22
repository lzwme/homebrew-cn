class Superseedr < Formula
  desc "BitTorrent Client in your Terminal"
  homepage "https://github.com/Jagalite/superseedr"
  url "https://ghfast.top/https://github.com/Jagalite/superseedr/archive/refs/tags/v0.9.28.tar.gz"
  sha256 "496d081ca1bcd7df05dfc4b2532a0fd8fb0b0e92a67f28f1a3277892fe6334fb"
  license "GPL-3.0-or-later"
  head "https://github.com/Jagalite/superseedr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3bd5e2cc68207cc0b7e46351d47d9ebe1e5d9ab86dee8c5437d51064f10261b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "578c6d088af3818e652629ae3a39ba85a63e5c70ecd4cc8f0e9e592f6a2a579d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c6a4c9e07e51fff39e31a04b024f949227e4241693f6b00da7e647751e4c0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d03b548485055980f3f0f11b8b4c4c0fa045027447c28581e8d05cb7456e9c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7e7f425a212e6b8a8e4791535392f6d1ddf84f35d0acc9d673636ed4a6280d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "657bf70b2994aec8704dceb2b8865226a4b13a9b13ac9d8a36dc90b073d15704"
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