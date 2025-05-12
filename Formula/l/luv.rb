class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https:github.comluvitluv"
  url "https:github.comluvitluvarchiverefstags1.51.0-0.tar.gz"
  sha256 "61f49840c067a8dec288dc841ea5cc20e81852d295068805c4ca1d744c82da7d"
  license "Apache-2.0"
  head "https:github.comluvitluv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "645494821fe3ea9437886f9fae19acb1aecaa12e4de44188ca412e5699723c03"
    sha256 cellar: :any,                 arm64_sonoma:  "f7712722a40fb8b61d679db25c253c2a85f75dda7aa468d1896f66efb56b2b15"
    sha256 cellar: :any,                 arm64_ventura: "ae484b1ae8dc52607dec941d0a7bd400f5f7690f9711eeca1d8faeca786522d9"
    sha256 cellar: :any,                 sonoma:        "cdfb1618a657456b48619a0b2a16021b819bf8254fe1347a45c1f90e11e75d4b"
    sha256 cellar: :any,                 ventura:       "dec71cd096c782dbf401af937315c0d77c1bb88c7803c94bcad51d3db358ae43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f2c03a600a7c1b36ef5fa75aed8ec902b3b7ccba2d985bb3258344a6e8455dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d770b219ac23b64adca73fc1fbc68543f03c88d0c5b6edd7f12865a718cb2a4"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https:github.comlunarmoduleslua-compat-5.3archiverefstagsv0.14.4.tar.gz"
    sha256 "a9afa2eb812996039a05c5101067e6a31af9a75eded998937a1ce814afe1b150"
  end

  def install
    resource("lua-compat-5.3").stage buildpath"depslua-compat-5.3" unless build.head?

    args = %W[
      -DWITH_SHARED_LIBUV=ON
      -DLUA_BUILD_TYPE=System
      -DLUA_COMPAT53_DIR=#{buildpath}depslua-compat-5.3
      -DBUILD_MODULE=ON
    ]

    system "cmake", "-S", ".", "-B", "buildjit",
                    "-DWITH_LUA_ENGINE=LuaJIT",
                    "-DBUILD_STATIC_LIBS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildjit"
    system "cmake", "--install", "buildjit"

    system "cmake", "-S", ".", "-B", "buildlua",
                    "-DWITH_LUA_ENGINE=Lua",
                    "-DBUILD_STATIC_LIBS=OFF",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args, *std_cmake_args
    system "cmake", "--build", "buildlua"
    system "cmake", "--install", "buildlua"
  end

  test do
    (testpath"test.lua").write <<~LUA
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    LUA

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("lua test.lua")
  end
end