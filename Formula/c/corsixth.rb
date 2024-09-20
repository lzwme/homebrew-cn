class Corsixth < Formula
  desc "Open source clone of Theme Hospital"
  homepage "https:github.comCorsixTHCorsixTH"
  url "https:github.comCorsixTHCorsixTHarchiverefstagsv0.67.tar.gz"
  sha256 "4e88cf1916bf4d7c304b551ddb91fb9194f110bad4663038ca73d31b939d69e3"
  license "MIT"
  revision 1
  head "https:github.comCorsixTHCorsixTH.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia:  "869c7e2ff9e9af71a6b8f7fd39444b3544471832c24334f189e77ecceabb5602"
    sha256 arm64_sonoma:   "753b467230849193995df1896fdad06d676fdf0b9d9a2874bfab2c884722097e"
    sha256 arm64_ventura:  "8f40760b12987c4563a65dfe7bb6797e5726ecfc615983660f0508f179d39aa2"
    sha256 arm64_monterey: "8f4a453fddd84c16c5a7359dd32343a08c3049c0297e3ee822d32b95f81e443b"
    sha256 sonoma:         "9533e126bf883c696cff563b4073e66b73a76c5ee8b5dabf9584aa2993583684"
    sha256 ventura:        "1b11fdf93d13e5b07ec0f8e4de0f50ff17b421a561da1f46b30556ed8d4937f7"
    sha256 monterey:       "b4baf26ba433ef5bf8637f8491a5e8bd2a45c2e181ab806a72437c61be405fe0"
    sha256 x86_64_linux:   "3bb1fcde57e74e97f5a94c2b0d8d438901b0bef8b85898c5b80681ae9d080acd"
  end

  depends_on "cmake" => :build
  depends_on "luarocks" => :build
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "lpeg"
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

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