class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https:www.weechat.org"
  url "https:weechat.orgfilessrcweechat-4.1.2.tar.xz" # if after 4.1.2, should be able to remove below 0879f9e patch
  sha256 "9a9b910fbe768bb9de7c7ac944f5db8f233833f345b2e505e16ec6ef35effbb5"
  license "GPL-3.0-or-later"
  revision 1
  head "https:github.comweechatweechat.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "ec4f1ba037b451570e576ccf72f432407f1d809a1e2dcc9a8f7a619284f8929f"
    sha256 arm64_ventura:  "63b07d78ffc9f2b20d1796cb1945837688794d8a880d4f99005dfc5305d64c15"
    sha256 arm64_monterey: "6aa679aba4747e6717f0d8bf469c00638fb22931ab1e1c34be7dccd5a7c9f508"
    sha256 sonoma:         "0fb9959d0baae13e1122d3e0ba858a3ffcf86de2c44fe156005d39bf9597173b"
    sha256 ventura:        "6e7b761df134dcea228000db713de73ff5aacfc2f2d19a4b82a176c5172d3dc8"
    sha256 monterey:       "81ffd37bf627867c1762ee3b33662309a83385d4be6edcb25b1921a642b2d9ac"
    sha256 x86_64_linux:   "5c506249ea0493cbb466bcf5041f13c075a0001373a1b4843d76a3e0b15c781f"
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