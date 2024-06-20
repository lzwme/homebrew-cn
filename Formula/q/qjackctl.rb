class Qjackctl < Formula
  desc "Simple Qt application to control the JACK sound server daemon"
  homepage "https://qjackctl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/qjackctl/qjackctl/1.0.0/qjackctl-1.0.0.tar.gz"
  sha256 "0adcc7c45938766b6cd7ab089a86232514c5051f15d48c62be702aaeffd012c8"
  license "GPL-2.0-or-later"
  head "https://git.code.sf.net/p/qjackctl/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/qjackctl[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "5c0c5ad6ba0075f2dd20c6d9a82ead064eab67c79a44052311c08da7e63da7cc"
    sha256 arm64_ventura:  "1b1dbce842f4c95fa9d8e7f840ba0eb83a0adb2db6e86d3fd09da7ad033e4c86"
    sha256 arm64_monterey: "f5546e6f2ac99a06a563609f5573c83624f98100c2d8744100899f6af5cca1ac"
    sha256 sonoma:         "1925f9f15f47d005272349625395eb3bdcbf39bdac5373036436e3a8856a22c8"
    sha256 ventura:        "d6a0941befdc9ea76145775a226c59f7a3284658502928ce56e1ede67a8af653"
    sha256 monterey:       "f03f835c3ba99f5f8537e5496f5678cc6d03edf679702090cb4a8b24b1ba205f"
    sha256 x86_64_linux:   "69d441dcdde3bce1906a5331d3df5821a98d0e0c9b36e85eee4db802c03e78ea"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "qt"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -DCONFIG_DBUS=OFF
      -DCONFIG_PORTAUDIO=OFF
      -DCONFIG_XUNIQUE=OFF
    ]

    system "cmake", *args
    system "cmake", "--build", "."
    system "cmake", "--install", "."

    if OS.mac?
      prefix.install bin/"qjackctl.app"
      bin.install_symlink prefix/"qjackctl.app/Contents/MacOS/qjackctl"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "qt.qpa.xcb: could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/qjackctl --version 2>&1")
  end
end