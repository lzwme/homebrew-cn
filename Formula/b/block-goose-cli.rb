class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://ghfast.top/https://github.com/block/goose/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "d2bc76e4d0d2d7f8fb96e89da7b72a0d12c7728a401846c44b4b30ad2bbf55c7"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "321f625d23d9a55e140603ee700d3650f574773a09f0b56cc113a0aabcab0ef2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d037ffab66a6bc8fc53125b07341c0336e11802673282a7169292dc5d576b21d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "614eadac3e7dfa7c181550ec271d3cc5555a4c567a94f147abd1cfc3e1573aa1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d521d55e60391a72c798deb9f34a8b2686f84b81082e5267049a3f25c5cf1e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d713c66ba10f0a219a9f44860b007f2f3a4a181de30b00a127e4c2e33410dff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "553e621de43b8970663b1d0dfcb7386579c6f0ff123b7e835148d410f7bf5867"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    output = shell_output("#{bin}/goose info")
    assert_match "Paths:", output
    assert_match "Config dir:", output
    assert_match "Sessions DB (sqlite):", output
  end
end