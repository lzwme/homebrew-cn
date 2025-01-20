class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.9.3.tar.gz"
  sha256 "dc2f55c14875abf9958f543ecfd250c2631bc00302b7fb717d54b87686a3cb2d"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e80d7e274cd75210a54e7989daad6f82178ba8b492b28dba4191a21e413c303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bc29d1e28c7dcf696df8cbc242885cb0738d3bcdfa59c98434341b3c1518e65"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49a17e1e7fa9012850f309719373ea02d7d535802e204ea1ae2c3daeed0dd590"
    sha256 cellar: :any_skip_relocation, sonoma:        "c69ed0f6beb65b9bbcba69d357388594146985ac608404cee2e0d35fed4394cd"
    sha256 cellar: :any_skip_relocation, ventura:       "2d517e629ef90bf209ed302e059d3430427f0958c0ab339df8576504c24e60bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f8357cdf36b04bbde211b10095a8943583fed3e7fd0803c9dde2999e583bd09"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end