class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.1.2.tar.gz"
  sha256 "3137e9b0297612912b59694b3453cf6707ca3722c6c7c4d136ab8754baad3ed4"
  license "BSD-2-Clause"
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "692c6df3b4c2a1f94b7ace213b171537a05564856dd4e46276c3f07b1b580a9d"
    sha256 cellar: :any,                 arm64_ventura:  "7b91662a1f338777e4c5bd83a41b11abce6b03b571daa912194306aa5f970752"
    sha256 cellar: :any,                 arm64_monterey: "3bf6427c233499349fbf5ed166858f88e0f15594cacf0b6aed767fab63dca53a"
    sha256 cellar: :any,                 sonoma:         "188785b0270dcb42b1a68415d042ed08456c0a21411dee748521cfa946aa8ff4"
    sha256 cellar: :any,                 ventura:        "9275c0e341f10fd5f24f2d3c9fd5447487e92e80eade45b6f3ba82f5874b9dec"
    sha256 cellar: :any,                 monterey:       "f54477a5efb046cff85527fdc4f3797ff1c4efd069a67a42963fca12bedf1905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f350cb3678b1e3d3d20d8a82e8c9a27043c2f5298a60bc2bc8921d60ca1100d8"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # Avoid keeping references to Homebrew's clangclang++ shims
    inreplace "srctriviaconfig.h.cmake",
              "#define COMPILER_INFO \"@CMAKE_C_COMPILER_ID@-@CMAKE_C_COMPILER_VERSION@\"",
              "#define COMPILER_INFO \"usrbinclang usrbinclang++\""

    args = std_cmake_args
    args << "-DCMAKE_INSTALL_MANDIR=#{doc}"
    args << "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}"
    args << "-DCMAKE_INSTALL_LOCALSTATEDIR=#{var}"
    args << "-DENABLE_DIST=ON"
    args << "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}"
    args << "-DREADLINE_ROOT=#{Formula["readline"].opt_prefix}"
    args << "-DENABLE_BUNDLED_LIBCURL=OFF"
    args << "-DENABLE_BUNDLED_LIBYAML=OFF"
    args << "-DENABLE_BUNDLED_ZSTD=OFF"

    if OS.mac?
      if MacOS.version >= :big_sur
        sdk = MacOS.sdk_path_if_needed
        lib_suffix = "tbd"
      else
        sdk = ""
        lib_suffix = "dylib"
      end

      args << "-DCURL_ROOT=#{Formula["curl"].opt_prefix}"
      args << "-DCURSES_NEED_NCURSES=ON"
      args << "-DCURSES_NCURSES_INCLUDE_PATH=#{sdk}usrinclude"
      args << "-DCURSES_NCURSES_LIBRARY=#{sdk}usrliblibncurses.#{lib_suffix}"
      args << "-DICONV_INCLUDE_DIR=#{sdk}usrinclude"
    else
      args << "-DENABLE_BUNDLED_LIBUNWIND=OFF"
      args << "-DCURL_ROOT=#{Formula["curl"].opt_prefix}"
    end

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  def post_install
    (var"libtarantool").mkpath
    (var"logtarantool").mkpath
    (var"runtarantool").mkpath
  end

  test do
    (testpath"test.lua").write <<~EOS
      box.cfg{}
      local s = box.schema.create_space("test")
      s:create_index("primary")
      local tup = {1, 2, 3, 4}
      s:insert(tup)
      local ret = s:get(tup[1])
      if (ret[3] ~= tup[3]) then
        os.exit(-1)
      end
      os.exit(0)
    EOS
    system bin"tarantool", "#{testpath}test.lua"
  end
end