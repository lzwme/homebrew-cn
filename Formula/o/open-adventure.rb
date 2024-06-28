class OpenAdventure < Formula
  desc "Colossal Cave Adventure, the 1995 430-point version"
  homepage "http://www.catb.org/~esr/open-adventure/"
  url "http://www.catb.org/~esr/open-adventure/advent-1.19.tar.gz"
  sha256 "9e3a845850587f3b82a480da72330f55529c6568278ca5dcab5429775a25e1c0"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/open-adventure.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?advent[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8b58ea57fc94e7e5d78a633cfded0e32ebe46e6c584198da2045c674d85ad35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f4abc89eb1ba51fe70087c34175242ac77cd8a7072e12c52f80d24ac7ed0ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823788b5c989833f75cf132d68966c291f40947848a2b766ccb6ad307a4a5692"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d9b4b32105645c7d6ae5a96315b80cbab181096a4dd46cee35be896b8b4a0c4"
    sha256 cellar: :any_skip_relocation, ventura:        "7696829dc8a02ce5fdb38bea18d962eaf00fafca82e0ee60c891b3459b449894"
    sha256 cellar: :any_skip_relocation, monterey:       "2d75eac4397870a341941b4e0e1cfdbdc29879a5fa42dd1ff71eb2b15724a50b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "086875ba8785868a58c1dfbb712cef156e5d0696d37cb9f3b9a36603cc6ad8ad"
  end

  depends_on "asciidoc" => :build
  depends_on "python@3.12" => :build
  depends_on "pyyaml" => :build

  uses_from_macos "libxml2" => :build
  uses_from_macos "libedit"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    python = Formula["python@3.12"].opt_bin/"python3.12"
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