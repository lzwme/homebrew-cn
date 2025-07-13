class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.12.3.tar.gz"
  sha256 "fb08f0f7e921c0e49edcc70560f3902af1c72f74e140cf681575b3a3c04b7f21"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "200e3d00f238e01c8ee3bdf2dc6b7b5a453898db6be397045ac908c95a2fdb41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ca7eed1ad531a73c519159b56be6a8bbe7e378869e0c3019a4e84c20fc99a04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "280f2f426393eb6365bac7b8d9905d064d12818856f4ec67a36897ac8ddf1f70"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c0a1eac9da7ee3759d36df627a271b18a18f8717f1bbfe189a4d78d85810d6"
    sha256 cellar: :any_skip_relocation, ventura:       "1ced26864b07087c65056795abbb8b872ec5c181f021c88dca2b7206ef3ba142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5229fd9d5f9544eebd984bf75da791651a4ca2e48a5dc36c86715a17dc0c6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02dbd25dff6b10301b9d8fac97f7aaae5264115d9910aeca0e5e36cf9b160d10"
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