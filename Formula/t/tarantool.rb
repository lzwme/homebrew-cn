class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.3.1.tar.gz"
  sha256 "c0f9d2160da2fa73a7dfb7e87d064d35554bf90358464e4c4ab9cced4695264e"
  license "BSD-2-Clause"
  revision 1
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  # The upstream release page (https:www.tarantool.ioendoclatestrelease)
  # simply links to GitHub releases, so we check the "latest" release directly.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5298f8fd26ac5cca02095bed524f471102e6e732477d7417e451ac2dfecae86b"
    sha256 cellar: :any,                 arm64_sonoma:  "7b71b83056da025a166c42b201cb34fbb2dd759d15530aad69eb5f3c3d6c6f68"
    sha256 cellar: :any,                 arm64_ventura: "48c9a273d79164f5058427033540616bd4dda795507860149725a46a2ffc5cda"
    sha256 cellar: :any,                 sonoma:        "114182d89ca1081c142002c70e52e62048fd5c012fc43860ef11ebab24a8af2e"
    sha256 cellar: :any,                 ventura:       "e680a57e44b09e2aeac0d1e3753849ede9bda9bf646b45bd9d257a44b72b76f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c16a9f89d4e515a874b56577571ddf3b568a742dbeb06a9184241c578d6fc8ce"
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