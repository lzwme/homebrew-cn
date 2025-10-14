class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://ghfast.top/https://github.com/Qalculate/qalculate-qt/releases/download/v5.8.0/qalculate-qt-5.8.0.tar.gz"
  sha256 "7c8e3074b709177462ead9b2b36736b18f1cb0f8e88dda3608911b9f7491c8e6"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a94c6a02e182b10f23de4fd032d21eda8b6a3c2934c7fbe678ff8caf5ea29221"
    sha256 cellar: :any,                 arm64_sequoia: "3d480fc2b12f7340c4ed68066fd6c1c63ae7c5be63de47a7e28ea980c673b238"
    sha256 cellar: :any,                 arm64_sonoma:  "b7fffe544cab8d445d021406624233220b1dce5d79f82dbc93790e91389859f3"
    sha256 cellar: :any,                 sonoma:        "c88a909d8f170f130c92da2416697c327cbf33095d6af7a12dd424dd83f45617"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f32626f540e2af94c44ff09541169cd2df334375c90ed3d7602ec2b3d3253b8"
  end

  depends_on "pkgconf" => :build
  depends_on "qttools" => :build

  depends_on "libqalculate"
  depends_on "qtbase"

  on_macos do
    depends_on "gmp"
    depends_on "mpfr"
  end

  def install
    system Formula["qtbase"].bin/"qmake", "qalculate-qt.pro"
    system "make"
    if OS.mac?
      prefix.install "qalculate-qt.app"
      bin.install_symlink prefix/"qalculate-qt.app/Contents/MacOS/qalculate-qt" => "qalculate-qt"
    else
      bin.install "qalculate-qt"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    assert_match version.to_s, shell_output("#{bin}/qalculate-qt -v")
  end
end