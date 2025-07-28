class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https://github.com/CorsixTH/CorsixTH"
  url "https://ghfast.top/https://github.com/CorsixTH/CorsixTH/archive/refs/tags/v0.69.0.tar.gz"
  sha256 "0f2dbdc2b8b6b2e4d5e80a6be02a72d586d0072efe867750a424746bd318f1f5"
  license "MIT"
  head "https://github.com/CorsixTH/CorsixTH.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "0decd168795988916b92e814d937027ff7999f75514e5b078fae4bef441f1d9c"
    sha256 arm64_sonoma:  "cd96d54ceef6d14a32a76c33b4b7317865c0cb1e955ef68aafaa0cca59b90f8e"
    sha256 arm64_ventura: "b26f4227f77757bc93023940afe00e05f91e7baeb30c3a0729d17f6df2f6946f"
    sha256 sonoma:        "67a6adecbab18ae3bf3c641d16e5db95d8201c68ec1c531ad2f6f4d35bd20d46"
    sha256 ventura:       "eba5905a0554c2c5afb557da9bdda642cae66f2d7ea603b189eedde5cf9188cd"
    sha256 arm64_linux:   "4cd091ab208d3dde25ee05a1b2f6e534493eb1e7fc378417ff43c08239ffc456"
    sha256 x86_64_linux:  "b0b9f5cd66ef36b1b733e3cd226d6e6e8f3722f71bacc1a7e1bb4f615ba74d0c"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lpeg"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "curl"

  on_linux do
    depends_on "mesa"
  end

  resource "luafilesystem" do
    url "https://ghfast.top/https://github.com/keplerproject/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  def install
    # Make sure I point to the right version!
    lua = Formula["lua"]

    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec/"vendor"
    # Append `;;` to keep default search path.
    ENV["LUA_PATH"] = luapath/"share/lua"/lua.version.major_minor/"?.lua;;"
    ENV["LUA_CPATH"] = luapath/"lib/lua"/lua.version.major_minor/"?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "build", r.name, "--tree=#{luapath}"
      end
    end

    datadir = OS.mac? ? prefix/"CorsixTH.app/Contents/Resources/" : pkgshare
    args = std_cmake_args + %W[
      -DLUA_INCLUDE_DIR=#{lua.opt_include}/lua
      -DLUA_LIBRARY=#{lua.opt_lib/shared_library("liblua")}
      -DLUA_PROGRAM_PATH=#{lua.opt_bin}/lua
      -DCORSIX_TH_DATADIR=#{datadir}
    ]
    # On Linux, install binary to libexec/bin so we can put an env script with LUA_PATH in bin.
    args << "-DCMAKE_INSTALL_BINDIR=#{libexec}/bin" unless OS.mac?

    system "cmake", ".", *args
    system "make"
    if OS.mac?
      resources = %w[
        CorsixTH/CorsixTH.lua
        CorsixTH/Lua
        CorsixTH/Levels
        CorsixTH/Campaigns
        CorsixTH/Graphics
        CorsixTH/Bitmap
      ]
      cp_r resources, "CorsixTH/CorsixTH.app/Contents/Resources/"
      prefix.install "CorsixTH/CorsixTH.app"
    else
      system "make", "install"
    end

    lua_env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin_path = OS.mac? ? prefix/"CorsixTH.app/Contents/MacOS/CorsixTH" : libexec/"bin/corsix-th"
    (bin/"CorsixTH").write_env_script(bin_path, lua_env)
  end

  test do
    if OS.mac?
      lua = Formula["lua"]

      app = prefix/"CorsixTH.app/Contents/MacOS/CorsixTH"
      assert_includes app.dynamically_linked_libraries, "#{lua.opt_lib}/liblua.dylib"
    end

    PTY.spawn(bin/"CorsixTH") do |r, _w, pid|
      sleep 30
      sleep 30 if OS.mac? && Hardware::CPU.intel?
      Process.kill "KILL", pid

      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end

      assert_match "Welcome to CorsixTH", output
    end
  end
end