class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https:github.comCorsixTHCorsixTH"
  url "https:github.comCorsixTHCorsixTHarchiverefstagsv0.68.0.tar.gz"
  sha256 "54034b8434f5c583178405d2c84477f903fe2b15933b611f42230668e35d632e"
  license "MIT"
  head "https:github.comCorsixTHCorsixTH.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "f870772f5827546ce2d05d7c82f5aa04c35f5d95111a2f8f4291eb02d0eeb518"
    sha256 arm64_sonoma:  "a998b8cb521a5c46582038f6d8a89ed6e647341c71df2d265af0c2ffc109deda"
    sha256 arm64_ventura: "f33fb70d41df5fa4908989da6c640125723afee46e595b014fec646b0e22a0d4"
    sha256 sonoma:        "85a59fbbd11582ee897c97deb738fd4dbf9296cb4ba6ebc31e58dbd5d1362504"
    sha256 ventura:       "5f80e96e69be652083c55583cd7f5c624df10c076c309af4da609137faead94e"
    sha256 x86_64_linux:  "c4a8daafab979bc9e0795b94beff96c65f0e88a665559e5990b56f53ab1ae868"
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
    url "https:github.comkeplerprojectluafilesystemarchiverefstagsv1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  def install
    # Make sure I point to the right version!
    lua = Formula["lua"]

    ENV["TARGET_BUILD_DIR"] = "."
    ENV["FULL_PRODUCT_NAME"] = "CorsixTH.app"

    luapath = libexec"vendor"
    # Append `;;` to keep default search path.
    ENV["LUA_PATH"] = luapath"sharelua"lua.version.major_minor"?.lua;;"
    ENV["LUA_CPATH"] = luapath"liblua"lua.version.major_minor"?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "build", r.name, "--tree=#{luapath}"
      end
    end

    datadir = OS.mac? ? prefix"CorsixTH.appContentsResources" : pkgshare
    args = std_cmake_args + %W[
      -DLUA_INCLUDE_DIR=#{lua.opt_include}lua
      -DLUA_LIBRARY=#{lua.opt_libshared_library("liblua")}
      -DLUA_PROGRAM_PATH=#{lua.opt_bin}lua
      -DCORSIX_TH_DATADIR=#{datadir}
    ]
    # On Linux, install binary to libexecbin so we can put an env script with LUA_PATH in bin.
    args << "-DCMAKE_INSTALL_BINDIR=#{libexec}bin" unless OS.mac?

    system "cmake", ".", *args
    system "make"
    if OS.mac?
      resources = %w[
        CorsixTHCorsixTH.lua
        CorsixTHLua
        CorsixTHLevels
        CorsixTHCampaigns
        CorsixTHGraphics
        CorsixTHBitmap
      ]
      cp_r resources, "CorsixTHCorsixTH.appContentsResources"
      prefix.install "CorsixTHCorsixTH.app"
    else
      system "make", "install"
    end

    lua_env = { LUA_PATH: ENV["LUA_PATH"], LUA_CPATH: ENV["LUA_CPATH"] }
    bin_path = OS.mac? ? prefix"CorsixTH.appContentsMacOSCorsixTH" : libexec"bincorsix-th"
    (bin"CorsixTH").write_env_script(bin_path, lua_env)
  end

  test do
    if OS.mac?
      lua = Formula["lua"]

      app = prefix"CorsixTH.appContentsMacOSCorsixTH"
      assert_includes app.dynamically_linked_libraries, "#{lua.opt_lib}liblua.dylib"
    end

    PTY.spawn(bin"CorsixTH") do |r, _w, pid|
      sleep 30
      Process.kill "KILL", pid

      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end

      assert_match "Welcome to CorsixTH", output
    end
  end
end