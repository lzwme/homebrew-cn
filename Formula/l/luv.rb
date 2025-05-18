class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https:github.comluvitluv"
  url "https:github.comluvitluvarchiverefstags1.51.0-1.tar.gz"
  sha256 "d4a11178ae8e16ba5886799ea91905dd9b0b479c75aebd67866d37373e41526f"
  license "Apache-2.0"
  head "https:github.comluvitluv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16a81eb3ddde559c8ff70e156d3074147397781669a9c17c5fa26b90daa659d9"
    sha256 cellar: :any,                 arm64_sonoma:  "e20c2a94e3d7ee950f8603955110bfc16d63b716da7a5bd857760905651db3b6"
    sha256 cellar: :any,                 arm64_ventura: "fc890936cace3f29f66ccd430cb2f0eecd5c414792484ab3257eb396ef0d7842"
    sha256 cellar: :any,                 sonoma:        "0b15ebe460d36241159d9edfe302a5fd885e397f4532b5a8aad8cbbd12044766"
    sha256 cellar: :any,                 ventura:       "5203840ddd749196567a7a93e52964d0157dd30b0a1a481a28155b0c7f9df142"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8610e16fce0c69eec05792b55040b0afa027a94b42057e8518ca65a31eec13e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7498d20bd2e167f2740e3419a999463b7253014ffc0a9af35e32732fe0a5988b"
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