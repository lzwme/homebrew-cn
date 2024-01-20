class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.0.0.tar.gz"
  sha256 "41dee7d752839e47b55dafeca424937e15be2d72d5a002ccc3b7f23dc8dbee3f"
  license "BSD-2-Clause"
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07c8259c2ec1f4a340bfffedf83aa823c6b37320d17880247bb5ffcb2ca3e284"
    sha256 cellar: :any,                 arm64_ventura:  "29f7a1301f5e9707f643d81ffc4eebc67ffd58c754e458551f776a69d599cd3b"
    sha256 cellar: :any,                 arm64_monterey: "4bf8b5bf77dd837c97e16f07aabebbd13deab256edc4d02f64a118b79b4f8119"
    sha256 cellar: :any,                 sonoma:         "723a44cfcb7b2c51379b0b38ac660a621ea7a4c869d4bad83fed586419f1a53e"
    sha256 cellar: :any,                 ventura:        "545aafdbbd8d93a279e46e5276420e6fd1ca15000c14e455f4e37d048c54bc15"
    sha256 cellar: :any,                 monterey:       "10cf7a1014b46116ae3944cac854a7af0a05d3474a5e2b3dddb0f927fafae1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffefe3c7ea87d04417975b89222d1d620459ef4880ca781b6e8ff2703053373b"
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
    local_user = ENV["USER"]
    inreplace etc"defaulttarantool", (username\s*=).*, "\\1 '#{local_user}'"

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