class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https:qalculate.github.io"
  url "https:github.comQalculateqalculate-qtreleasesdownloadv5.4.0qalculate-qt-5.4.0.tar.gz"
  sha256 "a97d1813bd68562465657136ebe7c3fb925d442efadc5aa14ac3806c152d2816"
  license "GPL-2.0-or-later"
  head "https:github.comQalculateqalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "bd4785b1df5a1e2654c2f52ee1ff14cdedcf7300bcd7adc335bcad346c9592fd"
    sha256 cellar: :any,                 arm64_ventura: "a8ef7981a30cb2fb7a3763e7806ef737dd326fb950560d83c39fbf5fc8cc1e66"
    sha256 cellar: :any,                 sonoma:        "d7b281998172198a8b18ca087faa2530295e93c15db04ca207af2d326333b21b"
    sha256 cellar: :any,                 ventura:       "7b00f4a57057f7fb9d80ebee909b56784fa50362a0370f1d56a37d184681e7d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2760bf55598792a6173db0042e3c1809eb4846ebe2fdbd5782e844a0cd6e6364"
  end

  depends_on "pkgconf" => :build

  depends_on "libqalculate"
  depends_on "qt"

  on_macos do
    depends_on "gmp"
    depends_on "mpfr"
  end

  def install
    system Formula["qt"].bin"qmake", "qalculate-qt.pro"
    system "make"
    if OS.mac?
      prefix.install "qalculate-qt.app"
      bin.install_symlink prefix"qalculate-qt.appContentsMacOSqalculate-qt" => "qalculate-qt"
    else
      bin.install "qalculate-qt"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match version.to_s, shell_output("#{bin}qalculate-qt -v")
  end
end