class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://download.tarantool.org/tarantool/src/tarantool-3.4.1.tar.gz"
  sha256 "d75ba384840abcc5f0a6a7fbd34480cd637eb123216b2e90535bb914d4921086"
  license "BSD-2-Clause"
  version_scheme 1
  head "https://github.com/tarantool/tarantool.git", branch: "master"

  # The upstream release page (https://www.tarantool.io/en/doc/latest/release/)
  # simply links to GitHub releases, so we check the "latest" release directly.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2cc987748674384ffb14d5e990bd64832d55ed6d604adb734a96aac23949338b"
    sha256 cellar: :any,                 arm64_sonoma:  "47b1e8b8416c3062ed9af87bc1ada4ad505d733509923e70b763190dbf22444a"
    sha256 cellar: :any,                 arm64_ventura: "9f6135d5abbc91dfd60a654261a17cef03d9fcba8ef29cff0cb83896587e1818"
    sha256 cellar: :any,                 sonoma:        "b60ba5d8496282e24c0f98d13545143677299b08f43a45ad4d6e1db7e7541b57"
    sha256 cellar: :any,                 ventura:       "ef58f0fd6540f446833dfd9c93fc7ce7c605c31f46e741a5fcbf2770fdd5585a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5902d674d98b898a87636e1fc128804038e33a34843548d5ece4d66c6f71e9a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a742ffddf77a5fc1626d81137c78ad2ba28eed543858a9f97d387106a619f622"
  end

  depends_on "cmake" => :build
  depends_on "curl" # curl 8.4.0+
  depends_on "icu4c@77"
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