class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:weechat.org"
  url "https:weechat.orgfilessrcweechat-4.5.1.tar.xz"
  sha256 "67c143c7bc70e689b9ea86df674c9a9ff3cf44ccc9cdff21be6a561d5eafc528"
  license "GPL-3.0-or-later"
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "02873a614850f0a5977b7deb6ea92a7e784caf5c1a835f617043b3d1a25eda37"
    sha256 arm64_sonoma:  "dbb1bcf87da4ed172a284fe568920605284ee9ea2bb89606c4c641a79f39f505"
    sha256 arm64_ventura: "5fa611726ec3d10e9dcfe63699a940c73850a634b9d090cc1378bd7ab3132cb3"
    sha256 sonoma:        "b01757a1f205e773768c2e56eb83f3c2d89f154cc2df8d41c77c6b6ca868ab18"
    sha256 ventura:       "5f0809ff7e9f2008e6dcabf06c326b1f67f562315b91992d9b53e700f7a96699"
    sha256 x86_64_linux:  "0fcaccb8f711c9401b2982e48bee2befbf5c0cd8e6405754e9ca41c9c50939ef"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "gettext" => :build # for xgettext
  depends_on "pkgconf" => :build
  depends_on "aspell"
  depends_on "cjson"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.13"
  depends_on "ruby"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "tcl-tk"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "libgpg-error"
  end

  def python3
    which("python3.13")
  end

  def install
    pyver = Language::Python.major_minor_version python3
    # Help pkgconf find python as we only provide `python3-embed` for aliased python formula
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