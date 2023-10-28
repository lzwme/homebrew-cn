class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.1.1.tar.xz"
  sha256 "774238614d8e63e4d3d5a73a6cb640ec76fe06cc982b87a8c923651579277675"
  license "GPL-3.0-or-later"
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "1c1b8b81d1b999b949c37c8d2b2e67ae745df2458618b57d47bbcd763124fd11"
    sha256 arm64_ventura:  "74efd7834997580b064815770565563472b3f44ea118b17e2c0e977d500a0ba7"
    sha256 arm64_monterey: "e161f9f382a8a9346b3298324097c28344b422093dd4d17c9cc0597ab97d862b"
    sha256 sonoma:         "1323674d3770c5cb95c83528da8f6f8d724b4b91bfc1f7077eb97695a15df993"
    sha256 ventura:        "0589c31e1534830ea3638f770cfb5d7f82888c09a95261f2c3b67fbe83d9f9d9"
    sha256 monterey:       "f127a9f181b5c6ab62c05f5cf62f91a41340dd79b9f97cacfff02e5783ffbb49"
    sha256 x86_64_linux:   "79c138363271a68727d5ef97d53026011b4ab732c5e65f961ec2ed76fbb9e57e"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
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

  def python3
    which("python3.12")
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkg-config find python as we only provide `python3-embed` for aliased python formula
    inreplace "cmake/FindPython.cmake", " python3-embed ", " python-#{pyver}-embed "

    args = %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{Formula["gnutls"].pkgetc}/cert.pem
      -DENABLE_JAVASCRIPT=OFF
      -DENABLE_PHP=OFF
    ]

    if OS.linux?
      args << "-DTCL_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
      args << "-DTK_INCLUDE_PATH=#{Formula["tcl-tk"].opt_include}/tcl-tk"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end