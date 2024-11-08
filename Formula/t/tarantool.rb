class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.2.1.tar.gz"
  sha256 "604566ceacb4db9ea6b4f2e29dbed587a9e5721abb49b764906e1a8b19153ea9"
  license "BSD-2-Clause"
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fb1af47e6109d954e5fefad0702033a1de5df468439e8b8d3c0db829d0e1d1bd"
    sha256 cellar: :any,                 arm64_sonoma:  "43b2194ea7f5e4b508773a9a57800766f10c7917d1e9fe6e8f137024c4bbba4f"
    sha256 cellar: :any,                 arm64_ventura: "1d35b655dadb1fd04ea5823216af216ef01f23e029c0f11cf9d2b4aab2bebb13"
    sha256 cellar: :any,                 sonoma:        "a8b380cd42970a801f88e927efd72f0018d6a9ed61c1e0b368e01523bb2c7d42"
    sha256 cellar: :any,                 ventura:       "30adcc9c64a39a3d36349588d30997a39ce431eb2dcba245ec7a0bbe0c1a33b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd641a562b4b4a0aa03f07bedb97fdbc6367470ac86151053eee845222505eff"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c@76"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

  def install
    # Workaround for clang >= 16 until upstream fix is available[^1].
    # Also, trying to apply LuaJIT commit[^2] worked on Xcode 16 but caused issue on Xcode 15.
    #
    # [^1]: https:github.comtarantooltarantoolissues10566
    # [^2]: https:github.comLuaJITLuaJITcommit2240d84464cc3dcb22fd976f1db162b36b5b52d5
    ENV.append "LDFLAGS", "-Wl,-no_deduplicate" if DevelopmentTools.clang_build_version >= 1600

    icu4c = deps.find { |dep| dep.name.match?(^icu4c(@\d+)?$) }
                .to_formula
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_DIST=ON
      -DCURL_ROOT=#{Formula["curl"].opt_prefix}
      -DCURL_ROOT_DIR=#{Formula["curl"].opt_prefix}
      -DICU_ROOT=#{icu4c.opt_prefix}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DREADLINE_ROOT=#{Formula["readline"].opt_prefix}
      -DENABLE_BUNDLED_LIBCURL=OFF
      -DENABLE_BUNDLED_LIBUNWIND=OFF
      -DENABLE_BUNDLED_LIBYAML=OFF
      -DENABLE_BUNDLED_ZSTD=OFF
      -DLUAJIT_NO_UNWIND=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (var"libtarantool").mkpath
    (var"logtarantool").mkpath
    (var"runtarantool").mkpath
  end

  test do
    (testpath"test.lua").write <<~LUA
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
    LUA
    system bin"tarantool", "#{testpath}test.lua"
  end
end