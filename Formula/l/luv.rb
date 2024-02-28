class Luv < Formula
  desc "Bare libuv bindings for lua"
  homepage "https:github.comluvitluv"
  url "https:github.comluvitluvarchiverefstags1.48.0-1.tar.gz"
  sha256 "99042665a3fb486b8d0c80d0130e62b918abbad069e908eb333765462245e275"
  license "Apache-2.0"
  head "https:github.comluvitluv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5aae0b2a821ea4f2bd6fccfde79f1676e9fa75059839e980e90671f53cbcc40f"
    sha256 cellar: :any,                 arm64_ventura:  "f18cc38c04efa46ebab892b364932664b37b4696d8527cc87b91eded6e16cd29"
    sha256 cellar: :any,                 arm64_monterey: "c2820b8386c837dbd439a5f11d065be66445f9fc66d4336b753b94c0512725ea"
    sha256 cellar: :any,                 sonoma:         "108134bffde4000d48c070aa08cf42d0e6f854416a78a484ae8b2e6e1b2ba33c"
    sha256 cellar: :any,                 ventura:        "e3af82b8ad45e2b82be63390242b69fc8c330f531af29b36eaf9a4d1a4446bf9"
    sha256 cellar: :any,                 monterey:       "71c535178777264ea17dd54bd494ee80e06c500d14f0558ee6b547e9b482eda7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e74b2eaa0b2eba1f018eb2f27ebc6ef40f05198d35eb47c306c09b43ce87735"
  end

  depends_on "cmake" => :build
  depends_on "lua" => [:build, :test]
  depends_on "luajit" => [:build, :test]
  depends_on "libuv"

  resource "lua-compat-5.3" do
    url "https:github.comlunarmoduleslua-compat-5.3archiverefstagsv0.12.tar.gz"
    sha256 "1ad84bb7d78cd3d0f8b6edbbb4c3a649f2b2c58c0f4b911b134317ea76c75135"
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
    (testpath"test.lua").write <<~EOS
      local uv = require('luv')
      local timer = uv.new_timer()
      timer:start(1000, 0, function()
        print("Awake!")
        timer:close()
      end)
      print("Sleeping");
      uv.run()
    EOS

    expected = <<~EOS
      Sleeping
      Awake!
    EOS

    assert_equal expected, shell_output("luajit test.lua")
    assert_equal expected, shell_output("lua test.lua")
  end
end