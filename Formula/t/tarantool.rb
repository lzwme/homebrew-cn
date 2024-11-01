class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https:tarantool.org"
  url "https:download.tarantool.orgtarantoolsrctarantool-3.2.0.tar.gz"
  sha256 "16a6d54a67f5f954cf784175dfcdb2b549c04ed1414e76256743e1fd4a560289"
  license "BSD-2-Clause"
  revision 2
  version_scheme 1
  head "https:github.comtarantooltarantool.git", branch: "master"

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bff37ca289d3df826b015ea6ebe52768f4008d048ab0f65a4270c0824b556a95"
    sha256 cellar: :any,                 arm64_sonoma:  "c1ee7443668cf4daa12d94c7bfbbd862d496d3db39b85de6e0c60dfaa13e7541"
    sha256 cellar: :any,                 arm64_ventura: "825a3045ee59043164ec703ab617a8ad10f56fd7e07b311c89e049330d8ee985"
    sha256 cellar: :any,                 sonoma:        "fc0549f96990073d51f54e713c8f22166afcd2dec10292c285ddb4ce6333d452"
    sha256 cellar: :any,                 ventura:       "827542a4434d9851158db60471ce0ce2c9d24a8aac2bf5f1fa3629c08fa6905c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c42bbd3188fb78a41fc23f9f65cc63e9a59f42ec3bad4e02e6f8891b8ac7f32a"
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