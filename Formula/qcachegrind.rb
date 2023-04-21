class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/23.04.0/src/kcachegrind-23.04.0.tar.xz"
  sha256 "e721f45994ca756876914008951191b54ca21a01c4019e3bcfe64058232028c4"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "958292e0438c3fad821097c35a21eb6770f6fac5eac4fe330aa5d6489c2db021"
    sha256 cellar: :any,                 arm64_monterey: "2925b364b325dbe8a2584fbe5d86d6e1fbcc780658af6ee8c730cab1c01e9745"
    sha256 cellar: :any,                 arm64_big_sur:  "9bce93e184ac1960d2412470c24f55b4cfcd6e29c4e4cb1b5a22532f7fbccfa0"
    sha256 cellar: :any,                 ventura:        "565974053a34e4ff13e34b000d0b9a34a8b436cccf2fe198dd90e7de4ec351d4"
    sha256 cellar: :any,                 monterey:       "c4db6395f967abd7ba4d7e6f87293157d951754af8c251bab6b3b88825362269"
    sha256 cellar: :any,                 big_sur:        "3f0c77f1186e5677815f8a03bf8f7c7c8982b09597b0df25e911c38b47e567dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e0e0e78d78efb121f2037ac1fc49283f11b244446287521f902ce2d9d8d66d7"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = []
    if OS.mac?
      # TODO: when using qt 6, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end