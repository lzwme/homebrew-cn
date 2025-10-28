class QalculateQt < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://ghfast.top/https://github.com/Qalculate/qalculate-qt/releases/download/v5.8.1/qalculate-qt-5.8.1.tar.gz"
  sha256 "3cfc08bdf46bb88db004d73be4f462825d5fb90345e645cd302bfe8f0feccdb4"
  license "GPL-2.0-or-later"
  head "https://github.com/Qalculate/qalculate-qt.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b413d6e599538f17e505f94ddca4c1157cee4d458ff0d34765596c8c21f9f1d"
    sha256 cellar: :any,                 arm64_sequoia: "bcc297917adeac48d196191ab44972c53cb7ff16788690c271fb547c9acc2e5e"
    sha256 cellar: :any,                 arm64_sonoma:  "8f0360ec33ad0fd4fe6652f43d2bcbc5c41d49cc0ffadcaaa7ecd1242620069a"
    sha256 cellar: :any,                 sonoma:        "26acd9503accf85cef5ef892f11a4ea4a87e18605893b3ffb10d6d99a1cba81d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34cb304e2d4823e6ad8da6965bade6c9d31270cdfab848e25a662f70674760bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bb677b45036b96616c61105287eb15dff494ff46b39125b9506b393a7a5d10d"
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