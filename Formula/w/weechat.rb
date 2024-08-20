class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.4.1.tar.xz"
  sha256 "e5de0bd14c2a57a505813a83c3d372648d2d9573dc72836857bf28717326936c"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "3b7b1eea1449997f40d7dee9c41e0ebe6382d63a51fea7bbfbec5281b7efe9e5"
    sha256 arm64_ventura:  "7ba8997849e0fbdc63fc3cf59ed5dc79a9b07de8c83aa0042b0565279ccb022e"
    sha256 arm64_monterey: "ce3887744d3e6820743b86b527579838e016b494366c4eafcfa61c21f30e022b"
    sha256 sonoma:         "6768eb9da03e9c652495c0e28d1a719c4eed3f399f95ddd1e13fc62ff0f689a2"
    sha256 ventura:        "800d0ca666bed6dbb5c5f58f6a19292814192af6714a3d985310abff52bbe50a"
    sha256 monterey:       "1a97e1908554cbe5dd04a9b74420e8d1e123943becf1431dc6b09173b097c86d"
    sha256 x86_64_linux:   "05816a6d42f00a19824cb1840aeccc1674037492172ea0caa012616fb6bcc7d2"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.12"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libgpg-error"
  end

  def python3
    which("python3.12")
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmakeFindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"weechat", "-r", "quit"
  end
end