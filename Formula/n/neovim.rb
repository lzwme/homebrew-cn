class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https:neovim.io"
  license "Apache-2.0"

  stable do
    url "https:github.comneovimneovimarchiverefstagsv0.10.2.tar.gz"
    sha256 "546cb2da9fffbb7e913261344bbf4cf1622721f6c5a67aa77609e976e78b8e89"

    # TODO: Remove when the following commit lands in a release.
    # https:github.comneovimneovimcommitfa79a8ad6deefeea81c1959d69aa4c8b2d993f99
    depends_on "libvterm"
    # TODO: Remove when the following commit lands in a release.
    # https:github.comneovimneovimcommit1247684ae14e83c5b742be390de8dee00fd4e241
    depends_on "msgpack"

    # Keep resources updated according to:
    # https:github.comneovimneovimblobv#{version}cmake.depsCMakeLists.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https:github.comorgsHomebrewdiscussions3611
    resource "tree-sitter-c" do
      url "https:github.comtree-sittertree-sitter-carchiverefstagsv0.21.3.tar.gz"
      sha256 "75a3780df6114cd37496761c4a7c9fd900c78bee3a2707f590d78c0ca3a24368"
    end

    resource "tree-sitter-lua" do
      url "https:github.comtree-sitter-grammarstree-sitter-luaarchiverefstagsv0.1.0.tar.gz"
      sha256 "230cfcbfa74ed1f7b8149e9a1f34c2efc4c589a71fe0f5dc8560622f8020d722"
    end

    resource "tree-sitter-vim" do
      url "https:github.comtree-sitter-grammarstree-sitter-vimarchiverefstagsv0.4.0.tar.gz"
      sha256 "9f856f8b4a10ab43348550fa2d3cb2846ae3d8e60f45887200549c051c66f9d5"
    end

    resource "tree-sitter-vimdoc" do
      url "https:github.comneovimtree-sitter-vimdocarchiverefstagsv3.0.0.tar.gz"
      sha256 "a639bf92bf57bfa1cdc90ca16af27bfaf26a9779064776dd4be34c1ef1453f6c"
    end

    resource "tree-sitter-query" do
      url "https:github.comnvim-treesittertree-sitter-queryarchiverefstagsv0.4.0.tar.gz"
      sha256 "d3a423ab66dc62b2969625e280116678a8a22582b5ff087795222108db2f6a6e"
    end

    resource "tree-sitter-markdown" do
      url "https:github.comtree-sitter-grammarstree-sitter-markdownarchiverefstagsv0.2.3.tar.gz"
      sha256 "4909d6023643f1afc3ab219585d4035b7403f3a17849782ab803c5f73c8a31d5"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 arm64_sequoia: "be2e4da3a98a4b08c2547ea4eb2eb46097772175db962a561e6c825474daa578"
    sha256 arm64_sonoma:  "7ddb9f6f9fdefdf2905b3704ab15ab9f9e1270223cdc775646cea6fce6a9501e"
    sha256 arm64_ventura: "3005a00e39203d2971b2993a9fd63d3db730798c697279d43eb6d2408e7e896b"
    sha256 sonoma:        "2ff5bdc6a9ede9d409055b73162c26d821e4788838a7bddf0991f7930d61430a"
    sha256 ventura:       "b6e38a65b0c7d110b1d9b2b860bafb79534a131e9f3fc396ed45e767170f01f8"
    sha256 x86_64_linux:  "d541db2153930dca721b05df7105389d1c8fe51ea88fd4a74c09b83eacd8c219"
  end

  head do
    url "https:github.comneovimneovim.git", branch: "master"
    depends_on "utf8proc"
  end

  depends_on "cmake" => :build
  depends_on "gettext"
  depends_on "libuv"
  depends_on "lpeg"
  depends_on "luajit"
  depends_on "luv"
  depends_on "tree-sitter"
  depends_on "unibilium"

  uses_from_macos "unzip" => :build

  on_linux do
    depends_on "libnsl"
  end

  def install
    resources.each do |r|
      r.stage(buildpath"deps-buildbuildsrc"r.name)
    end

    if build.stable?
      cd "deps-buildbuildsrc" do
        Dir["tree-sitter-*"].each do |ts_dir|
          cd ts_dir do
            if ts_dir == "tree-sitter-markdown"
              cp buildpath"cmake.depscmakeMarkdownParserCMakeLists.txt", "CMakeLists.txt"
            else
              cp buildpath"cmake.depscmakeTreesitterParserCMakeLists.txt", "CMakeLists.txt"
            end
            parser_name = ts_dir[^tree-sitter-(\w+)$, 1]
            system "cmake", "-S", ".", "-B", "build", "-DPARSERLANG=#{parser_name}", *std_cmake_args
            system "cmake", "--build", "build"
            system "cmake", "--install", "build"
          end
        end
      end
    end

    # Point system locations inside `HOMEBREW_PREFIX`.
    inreplace "srcnvimosstdpaths.c" do |s|
      s.gsub! "etcxdg", "#{etc}xdg:\\0"

      if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
        s.gsub! "usrlocalshare:usrshare", "#{HOMEBREW_PREFIX}share:\\0"
      end
    end

    # Replace `-dirty` suffix in `--version` output with `-Homebrew`.
    inreplace "cmakeGenerateVersion.cmake", "--dirty", "--dirty=-Homebrew"

    system "cmake", "-S", ".", "-B", "build",
                    "-DLUV_LIBRARY=#{Formula["luv"].opt_libshared_library("libluv")}",
                    "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_libshared_library("libuv")}",
                    "-DLPEG_LIBRARY=#{Formula["lpeg"].opt_libshared_library("liblpeg")}",
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
    refute_match "dirty", shell_output("#{bin}nvim --version")
    (testpath"test.txt").write("Hello World from Vim!!")
    system bin"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+sVimNeovimg", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath"test.txt").read.chomp
  end
end