class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/release-service/23.08.1/src/kcachegrind-23.08.1.tar.xz"
  sha256 "69ee24c45f9d975f0192b4353daadf278587a3c52537681d4ef6c684326e9d9a"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cec0f7c09979b22f3fecb5d1e53a343909aeaf6f6ba645d331ddc3858cfaf19b"
    sha256 cellar: :any,                 arm64_monterey: "967a8c5279a3e77a004b9aa5983bd66619db01c730ada59a7889bc7b1f35b6f3"
    sha256 cellar: :any,                 arm64_big_sur:  "6cc1a73d25ab9b1598d4ad6746545e14aa75b14bd2e7c10afc7378495e487a72"
    sha256 cellar: :any,                 ventura:        "2e42dc8e9dae6361ceff32c27f0c82cd657a10089cc7630045fa4a9764c75e36"
    sha256 cellar: :any,                 monterey:       "196b60a21524c54b7d6809d0365e22cfe86f4b6a5451f03c9c8c741aa6f3bd39"
    sha256 cellar: :any,                 big_sur:        "90ad61e4bf1b38e5d58b177ec8b61a1860bc341473963f6811b636b60e36a08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dfd2662f3e928b3ae37961ccdc8982cebffa706a993ae0abc6be1246c900612"
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