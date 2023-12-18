class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https:pdfpc.github.io"
  url "https:github.compdfpcpdfpcarchiverefstagsv4.4.1.tar.gz"
  sha256 "4adb42fd1844a7e2ab44709dd043ade618c87f2aaec03db64f7ed659e8d3ddad"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "0fa98a189234582e235215997734a148ef5f4b6f96a0279e5212426eaca55a05"
    sha256 arm64_ventura:  "e35ae948acccf50487a29318c6f1d204eefc15f0545115a4f957753723b2035c"
    sha256 arm64_monterey: "5830c312af0de512390b27bcc880da91b1909195a33be690dd9f4f595469cfe8"
    sha256 sonoma:         "dd22b140aec750615ee25dbad00cf8974154ff897d4097ee270f743b929e8f13"
    sha256 ventura:        "6f042b935bb90f53a418fe117d894c95468ab193e7e10bd81756ff7907e537c0"
    sha256 monterey:       "4c8be94abad2dec957196e7cf229c99f56bd790bde5fcf284bd61487dc9384e2"
    sha256 x86_64_linux:   "581f359bbbeca6405785b33d0d9d7f3b33e59184b76f89db2f29ec79b1faaf48"
  end

  head do
    url "https:github.compdfpcpdfpc.git", branch: "master"

    depends_on "discount"
    depends_on "json-glib"
    depends_on "libsoup@2"
    depends_on "qrencode"

    on_linux do
      depends_on "webkitgtk"
    end
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "poppler"

  def install
    # NOTE: You can avoid the `libsoup@2` dependency by passing `-DREST=OFF`.
    # https:github.compdfpcpdfpcblob3310efbf87b5457cbff49076447fcf5f822c2269srcCMakeLists.txt#L38-L40
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DMDVIEW=#{OS.linux?}", # Needs webkitgtk
                    "-DMOVIES=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin"pdfpc", "--version"
  end
end