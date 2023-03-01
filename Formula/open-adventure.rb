class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.13.tar.gz"
  sha256 "cd5e1e9682cf75c12ea915ed3e8a3eb26fcaceef8f1cfbf59011a0e4bb5fcc88"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50914f76931b2951c8756fa48f1862c3dd3efac04327d25d2155aad733dae20b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cb05a874dea90657fd61ade0d4e55d5a22bd17a99b7a2054f1cc32c46571234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0006269aabe535881d6878ca48c98d66f3c1e771529e221d3a58ed707951a1e"
    sha256 cellar: :any_skip_relocation, ventura:        "9fe310f062240016b61d1e048d2d3c0a73e9d62c7e9d59ec94167013aa093135"
    sha256 cellar: :any_skip_relocation, monterey:       "c78eb61825d5e2530dcdb65d2e95c91bb50971a6b6e28d95f319e47e6be2f9e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3004fc069484944d80ad96a0efc7d4c247cfbfa8886305e8023ff6dd3de2e659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92331ec444a1c67fe226f62c20d2012cf99c53dc9a06cfcfd0e2701d46d99c18"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.11" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.11"].opt_bin/"python3.11"
    system python, "./make_dungeon.py"
    system "make"
    bin.install "advent"
    system "make", "advent.6"
    man6.install "advent.6"
  end

  test do
    # there's no apparent way to get non-interactive output without providing an invalid option
    output = shell_output("#{bin}/advent --invalid-option 2>&1", 1)
    assert_match "Usage: #{bin}/advent", output
  end
end