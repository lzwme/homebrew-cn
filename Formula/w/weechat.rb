class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.1.3.tar.xz" # if after 4.1.2, should be able to remove below 0879f9e patch
  sha256 "db1e57bd7786d66859666d306b0646baad337238319a005362ad0d78615710ef"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "1950a510d702e6b350d2e740fbc7fdaab65be37683c4c3b8f88300b93bda52c3"
    sha256 arm64_ventura:  "2f4c5e4d388d30d1143aba6e4d7f7d8e18e22fcabe54c04a4d28c69316a98da5"
    sha256 arm64_monterey: "ce51bdc7021d57c9af313f7d96608ceea729bc79e782a85b05b00d7a0f810d71"
    sha256 sonoma:         "5cb757b9a1c52ff4b999bfee6f7b0aa0d62ed198ee39728afd45f245cfa8e738"
    sha256 ventura:        "ce3f6ef3ab61eaa6d06a317678ba4234d007c66ee25ef3067328245976ff0ec4"
    sha256 monterey:       "3db6a7144a658321a6197e11373ec513f1fa7d1d5ee627780366fac2c226d7be"
    sha256 x86_64_linux:   "4b67df002b184bef92b6ea806e2564b175183fb218ba8f2738dc68c796c01d52"
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

  patch do
    # Patch cmakeFindRuby.cmake to be aware of Ruby 3.3
    url "https:github.comweechatweechatcommit5c65a73432f278a0caf36363a8b01571f1c7236a.patch?full_index=1"
    sha256 "0879f9e21bd606726cd62a14cab76fcd8a4631c614c178cdb72c124a6c610cdc"
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
    system "#{bin}weechat", "-r", "quit"
  end
end