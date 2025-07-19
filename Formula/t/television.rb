class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.12.5.tar.gz"
  sha256 "c29aef30c26d7e41dec3d03e1a4ce469e22f5fd78627d5eea560d607c9ee637a"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db662e9878b6c2079e379565017d0ce8ad7cd5679fc5563260de8b87cb33fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0a5938dac7bf0df20fb6f729063063082f24c1491e697fe075a38a09a6fdec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a2d8584232e6b54c4df52b0a9102425686ae604c2457d7b3f29758bec4c9c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "16f59775c8a2476b29336f66e9cd5968f2b666a4fe0b0938860f751cf26dfa7a"
    sha256 cellar: :any_skip_relocation, ventura:       "4b4c351f0e3ebeab48a31ae889c83d9a022f435a2346b7ccb01efe542a0e0148"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34188fb29b6e14f7d033305232a73496b8444f83ee94a83dcda458389bd981d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1e76c5299f22814b22ef91102df895fd734d7077e69ccb5470c35c42261d5d2"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end