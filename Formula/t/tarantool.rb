class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.3.0.tar.gz"
  sha256 "01edc3125f12f10dc8e14e205c376a3d7fd2e5260841c920575a23eef795a290"
  license "BSD-2-Clause"
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a7ad0b5972996297a005773b6f84d5c8e0e9615925bb6e0ed30a69caa734853"
    sha256 cellar: :any,                 arm64_sonoma:  "30af8f7d1dc3a0e485b7cc680ea0558847e1635a59a24f58f719d4d619bc7afa"
    sha256 cellar: :any,                 arm64_ventura: "8272766e8ba48446a70b09d6992ac6fe0c6341632d0495b0c19ab54d574335f1"
    sha256 cellar: :any,                 sonoma:        "8e964cbd6dc05d81c2409b7ee927b37fa9d52024374e2203f4aa6ff9ee3bf2e3"
    sha256 cellar: :any,                 ventura:       "b4488b26fe00a3e2147f7a39bb6494a7fbdbea4484a39771bf9c3f0cc3aed11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef3986386b5e2b2a206fb1e505bd2781b36a205545fc565fc6738f5110ad1b4"
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