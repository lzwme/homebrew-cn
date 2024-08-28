class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.2.0.tar.gz"
  sha256 "16a6d54a67f5f954cf784175dfcdb2b549c04ed1414e76256743e1fd4a560289"
  license "BSD-2-Clause"
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dbb92f228bc943bc3fade520bb991bef523e2d2769c1519e1ce57adcbec95514"
    sha256 cellar: :any,                 arm64_ventura:  "dcb46fa9a42e6a680793c3d217ab97f131220d056e3779f967d4b08841fe8468"
    sha256 cellar: :any,                 arm64_monterey: "633a40ebfe5cd20040d5ec54480cc52a28683b916743c96da2c795843cd3f749"
    sha256 cellar: :any,                 sonoma:         "4604134c83663c1dc7029c97a6e2817bcbc62ef140c485a78e0992e586100869"
    sha256 cellar: :any,                 ventura:        "c591b9664ae51b148edbd776cb1afdc4c997cfed5d5fed65b8c7e1baec85a5c4"
    sha256 cellar: :any,                 monterey:       "f7a9da662f8f7a7343fae87b276542ae02735153705281e795f53e036ac513d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3293a7fe45aaccfba90e706325138882e2e408ef0fce719d0bc04692422f98be"
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