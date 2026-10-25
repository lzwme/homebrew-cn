class Tarantool < Formula
  desc "In-memory database and Lua application server"
  homepage "https://tarantool.org/"
  url "https://hb.bizmrg.com/tarantool_repo/sources/tarantool-3.8.1.tar.gz"
  sha256 "84ba3129bcfc2a7eeb30cea17a955b7b3f96615b960497d5ca60eac1d14fd090"
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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "9e6ccda0c367d2e11bab95da31c8e79148cb1bd7f8534a69466cf51bbdbad514"
    sha256 cellar: :any, arm64_tahoe:       "7667caf672fb1a1226669da6567d999f16ac0ca67a066b68a1b08ea0e9566e6d"
    sha256 cellar: :any, arm64_sequoia:     "d1bfc032e75731998b34d155bda4bab91042f316eec2a8aa138d9770ba568c66"
    sha256 cellar: :any, arm64_linux:       "6977bf47be24c80c14163d2d4822e21e6f15ecc5c8df29f52f9b2bf96bfb9e8b"
    sha256 cellar: :any, x86_64_linux:      "140e060e24b16885faacfb66713f1adaed09b99a49e5b1d0a512e25dc983d78f"
  end

  depends_on "cmake" => :build
  depends_on "icu4c@79"
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "readline"
  depends_on "zstd"

  uses_from_macos "curl", since: :sonoma # curl 8.4.0+
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libunwind"
  end

  def install
    icu4c = deps.find { |dep| dep.name.match?(/^icu4c(@\d+)?$/) }
                .to_formula
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      -DENABLE_DIST=ON
      -DICU_ROOT=#{icu4c.opt_prefix}
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix("openssl@4")}
      -DREADLINE_ROOT=#{formula_opt_prefix("readline")}
      -DENABLE_BUNDLED_LIBCURL=OFF
      -DENABLE_BUNDLED_LIBUNWIND=OFF
      -DENABLE_BUNDLED_LIBYAML=OFF
      -DENABLE_BUNDLED_ZSTD=OFF
      -DLUAJIT_NO_UNWIND=ON
    ]
    args << "-DCURL_ROOT_DIR=#{MacOS.sdk_for_formula(self).path}/usr" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    system bin/"tarantool", testpath/"test.lua"
  end
end