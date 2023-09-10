class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"

  stable do
    url "https://ghproxy.com/https://github.com/neovim/neovim/archive/v0.9.2.tar.gz"
    sha256 "06b8518bad4237a28a67a4fbc16ec32581f35f216b27f4c98347acee7f5fb369"

    # Remove when `mpack` resource is removed.
    depends_on "luarocks" => :build

    # Remove in 0.10.
    resource "mpack" do
      url "https://ghproxy.com/https://github.com/libmpack/libmpack-lua/releases/download/1.0.10/libmpack-lua-1.0.10.tar.gz"
      sha256 "18e202473c9a255f1d2261b019874522a4f1c6b6f989f80da93d7335933e8119"
    end

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/CMakeLists.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    resource "tree-sitter-c" do
      url "https://ghproxy.com/https://github.com/tree-sitter/tree-sitter-c/archive/v0.20.5.tar.gz"
      sha256 "694a5408246ee45d535df9df025febecdb50bee764df64a94346b9805a5f349b"
    end

    resource "tree-sitter-lua" do
      url "https://ghproxy.com/https://github.com/MunifTanjim/tree-sitter-lua/archive/v0.0.18.tar.gz"
      sha256 "659beef871a7fa1d9a02c23f5ebf55019aa3adce6d7f5441947781e128845256"
    end

    resource "tree-sitter-vim" do
      url "https://ghproxy.com/https://github.com/neovim/tree-sitter-vim/archive/v0.3.0.tar.gz"
      sha256 "403acec3efb7cdb18ff3d68640fc823502a4ffcdfbb71cec3f98aa786c21cbe2"
    end

    resource "tree-sitter-vimdoc" do
      url "https://ghproxy.com/https://github.com/neovim/tree-sitter-vimdoc/archive/v2.0.0.tar.gz"
      sha256 "1ff8f4afd3a9599dd4c3ce87c155660b078c1229704d1a254433e33794b8f274"
    end

    resource "tree-sitter-query" do
      url "https://ghproxy.com/https://github.com/nvim-treesitter/tree-sitter-query/archive/v0.1.0.tar.gz"
      sha256 "e2b806f80e8bf1c4f4e5a96248393fe6622fc1fc6189d6896d269658f67f914c"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "ed82c990549171cc7fc57adc63a497bd0695f49ee5873862bb2fa09812d3471c"
    sha256 arm64_monterey: "03599c7880db8ef50818df21b76fb520f8b5259dd8fee2f6fd9f670abd3c19ef"
    sha256 arm64_big_sur:  "443e25018cb6da8aadf9a98a79a5ab1e873fcc7b7842301aeef3c3ca9c638cfd"
    sha256 ventura:        "e5794d9525acc5e127b2b43e3b5a687dcb37434f16311a2f691310c5b26751a2"
    sha256 monterey:       "f3086448bcde12c4679ec8ceb3ade1d85a510816d425ba42c9efa42ad76b80b5"
    sha256 big_sur:        "de7e8957ecae7b11f927fc5d6136e9e3fe314b8c7e56e850dd5ce6820796f36a"
    sha256 x86_64_linux:   "4e558bb3bd69d373adfdb43c842fd48f7d7efc83fea99cc9b77bef6dfa34371f"
  end

  # TODO: Replace with single-line `head` when `lpeg`
  #       is no longer a head-only dependency in 0.10.0.
  head do
    url "https://github.com/neovim/neovim.git", branch: "master"
    depends_on "lpeg"
  end

  depends_on "cmake" => :build
  depends_on "lpeg" => :build # needed at runtime in 0.10.0
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libtermkey"
  depends_on "libuv"
  depends_on "libvterm"
  depends_on "luajit"
  depends_on "luv"
  depends_on "msgpack"
  depends_on "tree-sitter"
  depends_on "unibilium"

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "libnsl"
  end

  def install
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src"/r.name)
    end

    if build.stable?
      cd "deps-build/build/src" do
        # TODO: Remove `mpack` build block in 0.10.0.
        cd "mpack" do
          luajit = Formula["luajit"]
          lua_path = "--lua-dir=#{luajit.opt_prefix}"
          deps_build = buildpath/"deps-build"

          # The path separator for `LUA_PATH` and `LUA_CPATH` is `;`.
          ENV.prepend "LUA_PATH", deps_build/"share/lua/5.1/?.lua", ";"
          ENV.prepend "LUA_CPATH", deps_build/"lib/lua/5.1/?.so", ";"

          rock = "mpack-1.0.10-0.rockspec"
          output = Utils.safe_popen_read("luarocks", "unpack", lua_path, rock, "--tree=#{deps_build}")
          unpack_dir = output.split("\n")[-2]

          cd unpack_dir do
            system "luarocks", "make", lua_path, "--tree=#{deps_build}"
          end
        end

        Dir["tree-sitter-*"].each do |ts_dir|
          cd ts_dir do
            cp buildpath/"cmake.deps/cmake/TreesitterParserCMakeLists.txt", "CMakeLists.txt"

            parser_name = ts_dir[/^tree-sitter-(\w+)$/, 1]
            system "cmake", "-S", ".", "-B", "build", "-DPARSERLANG=#{parser_name}", *std_cmake_args
            system "cmake", "--build", "build"
            system "cmake", "--install", "build"
          end
        end
      end
    end

    # Point system locations inside `HOMEBREW_PREFIX`.
    inreplace "src/nvim/os/stdpaths.c" do |s|
      s.gsub! "/etc/xdg/", "#{etc}/xdg/:\\0"

      if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
        s.gsub! "/usr/local/share/:/usr/share/", "#{HOMEBREW_PREFIX}/share/:\\0"
      end
    end

    # Replace `-dirty` suffix in `--version` output with `-Homebrew`.
    inreplace "cmake/GenerateVersion.cmake", "--dirty", "--dirty=-Homebrew"

    # Needed to find `lpeg` in non-default prefixes.
    ENV.prepend "LUA_CPATH", Formula["lpeg"].opt_lib/"lua/5.1/?.so", ";"
    # Don't clobber the default search path
    ENV.append "LUA_PATH", ";", ";"
    ENV.append "LUA_CPATH", ";", ";"

    system "cmake", "-S", ".", "-B", "build",
                    "-DLUV_LIBRARY=#{Formula["luv"].opt_lib/shared_library("libluv")}",
                    "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_lib/shared_library("libuv")}",
                    *std_cmake_args

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    return if latest_head_version.blank?

    <<~EOS
      HEAD installs of Neovim do not include any tree-sitter parsers.
      You can use the `nvim-treesitter` plugin to install them.
    EOS
  end

  test do
    refute_match "dirty", shell_output("#{bin}/nvim --version")
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end