class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.5.0.tar.gz"
  sha256 "396780491b4f01c75f7098056e9a21562a687234085543bf52a5c5a6905f2dbc"
  license "BSD-2-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  # The upstream release page (https://www.tarantool.io/en/doc/latest/release/)
  # simply links to GitHub releases, so we check the "latest" release directly.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "062bf5f72121d2b53e7e3e90b0e3c142db341ba486744f79187d4faa70c095c7"
    sha256 cellar: :any,                 arm64_sequoia: "96d4bf9f6976d1cbbba9dae094a1bb88499d4b2ad263b2822ad121abb1cfc94c"
    sha256 cellar: :any,                 arm64_sonoma:  "75cdeb82e43c5867d938a0cce097283d43b89017d430d2e9ec1964f2941c17fd"
    sha256 cellar: :any,                 sonoma:        "4fa662142eb5f5be2b574feb3bcf8a9d759dcec63800119e6fde706a56670292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d195d21bf525cff7624dd482e495474256c1b89a22b29a17a6121692ffcda9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f677b2ac62d9cb56b1d7f4339313a49217f6b404a264fbc2317746280cea9d4"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c@78"
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
    # [^1]: https://github.com/tarantool/tarantool/issues/10566
    # [^2]: https://github.com/LuaJIT/LuaJIT/commit/2240d84464cc3dcb22fd976f1db162b36b5b52d5
    ENV.append "LDFLAGS", "-Wl,-no_deduplicate" if DevelopmentTools.clang_build_version >= 1600

    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
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
    (var/"lib/tarantool").mkpath
    (var/"log/tarantool").mkpath
    (var/"run/tarantool").mkpath
  end

  test do
    (testpath/"test.lua").write <<~LUA
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
    system bin/"tarantool", "#{testpath}/test.lua"
  end
end