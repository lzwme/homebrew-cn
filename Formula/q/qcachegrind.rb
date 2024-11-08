class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://apps.kde.org/kcachegrind/"
  url "https://download.kde.org/stable/release-service/24.08.3/src/kcachegrind-24.08.3.tar.xz"
  sha256 "6f51a60e44855b177c4d7972e3b560181c074ba5752ea42759624e03fbbf2e1b"
  license "GPL-2.0-or-later"
  head "https://invent.kde.org/sdk/kcachegrind.git", branch: "master"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "281286c4846d2905f180025f2590ad930478999ec92eaa402977accafa2256f9"
    sha256 cellar: :any,                 arm64_ventura: "c6c9f98895e246ce8682f5fbabc92d5b732aba041e2b762fd37b094ecf1cf391"
    sha256 cellar: :any,                 sonoma:        "bce139c76c148ce209c07d825fd1f5fc5cdfd4c842361fdacb745d148f0587eb"
    sha256 cellar: :any,                 ventura:       "2da943d17a82a529677066ea30540ac04342ecc27cbdbf99f8f2b6e152f08ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "947496619aff9abe26bd1cbb8bf306857c69dc6b18dba7a7a4526abf6086fb5f"
  end

  depends_on "graphviz"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    qt = Formula["qt"]
    system qt.opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end