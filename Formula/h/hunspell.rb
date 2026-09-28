class Hunspell < Formula
  desc "Spell checker and morphological analyzer"
  homepage "https://hunspell.github.io"
  url "https://ghfast.top/https://github.com/hunspell/hunspell/releases/download/v1.7.4/hunspell-1.7.4.tar.gz"
  sha256 "66ec82a577395fe9d471504267e6dd04615c76517c61af7c6b9c19e5e34e73c8"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8ba6861ac4fdc4bf782dd45b82782069db915c37974e61553ef86be5d599fe64"
    sha256 cellar: :any, arm64_tahoe:       "ea9c563e34dcfd74a81132f510b6551c6a0c5c04385d792333d01522e489afca"
    sha256 cellar: :any, arm64_sequoia:     "eaa5e935b12d371a471ce60516dbcac5a17d2b71628f48b569c144ce7cb83ae2"
    sha256 cellar: :any, arm64_linux:       "66b70207f08b1a6ca7d951b34a48ef1ae733349e48c957be4d33fa2ffc72425c"
    sha256 cellar: :any, x86_64_linux:      "4b639fe475b179f28657090184cf266a5a9b9dacf6c616237016337768a87f46"
  end

  depends_on "gettext" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "coreutils" => :build # for timeout in gh646.test
    depends_on "gettext"
  end

  conflicts_with "freeling", because: "both install 'analyze' binary"

  skip_clean "share/hunspell"

  def install
    system "./configure", "--disable-silent-rules",
                          "--with-ui",
                          "--with-readline",
                          *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"

    # Find dictionaries installed by other formulae
    share.install_symlink HOMEBREW_PREFIX/"share/hunspell"
  end

  def caveats
    <<~EOS
      Dictionary files (*.aff and *.dic) should be placed in
      ~/Library/Spelling/ or /Library/Spelling/.  Homebrew itself
      provides no dictionaries for Hunspell, but you can download
      compatible dictionaries from other sources, such as
      https://cgit.freedesktop.org/libreoffice/dictionaries/tree/ .
    EOS
  end

  test do
    system bin/"hunspell", "--help"
  end
end