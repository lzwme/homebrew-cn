class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-4.0.5.tar.xz"
  sha256 "3d72e61b05631dabdc283231768f938a85544b27e31fabfe13c57b4df5c5e3bb"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/weechat/weechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "fb1b19579e83515ae9909d20b6f6437292cc05bdc579dc6fd26b326d83e739ce"
    sha256 arm64_ventura:  "3e3bb0160ecd00b9e9c22e5c04ef682bcfa45c1b97bc51a29c899ef4e6bb1412"
    sha256 arm64_monterey: "284507a6939b9a3b0fb398daf4adfde9b96df74f3540a7d30c5493323a3daf70"
    sha256 sonoma:         "6b4ff03879a951b51683772655e921402cb3a1d447ad36e752431dd97fef9a60"
    sha256 ventura:        "f19ac616cb173b83a577894a217bde7ae641259083bd593ebafa9bbdcaa79e00"
    sha256 monterey:       "64ee25a1cfbafb24727bad9bf1ebeb6f9d0b0c08d5f38ab89dfa4948738edc15"
    sha256 x86_64_linux:   "4d6a6a110fa55295082e4b547fefbe0c4a7ad8f3d34ccc870e3dd29efb29a992"
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
  depends_on "python@3.11"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"

  def install
    python3 = "python3.11"
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