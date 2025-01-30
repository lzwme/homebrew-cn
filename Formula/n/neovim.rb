class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https:neovim.io"
  license "Apache-2.0"

  stable do
    url "https:github.comneovimneovimarchiverefstagsv0.10.4.tar.gz"
    sha256 "10413265a915133f8a853dc757571334ada6e4f0aa15f4c4cc8cc48341186ca2"

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
    # NOTE: The `install` method assumes that the parser name follows the final `-`.
    #       Please name the resources accordingly.
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
    sha256 arm64_sequoia: "70a2ed00de4a0e7bfeef6a6b9d3bec7623f086dd06266ea6d11d2e4ae7eeb381"
    sha256 arm64_sonoma:  "9d4af9c53f7394a20cdf4014b594a52d14b8f0f83b39fa041ab2d5ddc78da7e3"
    sha256 arm64_ventura: "f9ec03101ec565907c6f9a4b18d9673d75c642dbd6adb695e6dbe80b099cdfe2"
    sha256 sonoma:        "1ac71c2cc3b0c3521de71bb6ccb2c8d7da80cdccc1709c702792890379090503"
    sha256 ventura:       "f3503f4c9a4b6173067dbc2f7c6f00ed93b59c7be10875c1cf3ffe45206304c6"
    sha256 x86_64_linux:  "029a46cbee1a908551a0ff837881b6362d0d469fecd44b5736d9977e8691101b"
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

  def install
    if build.head?
      cmake_deps = (buildpath"cmake.depsdeps.txt").read.lines
      cmake_deps.each do |line|
        next unless line.match?(TREESITTER_[^_]+_URL)

        parser, parser_url = line.split
        parser_name = parser.delete_suffix("_URL")
        parser_sha256 = cmake_deps.find { |l| l.include?("#{parser_name}_SHA256") }.split.last
        parser_name = parser_name.downcase.tr("_", "-")

        resource parser_name do
          url parser_url
          sha256 parser_sha256
        end
      end
    end

    resources.each do |r|
      source_directory = buildpath"deps-buildbuildsrc"r.name
      build_directory = buildpath"deps-buildbuild"r.name

      parser_name = r.name.split("-").last
      cmakelists = case parser_name
      when "markdown" then "MarkdownParserCMakeLists.txt"
      else "TreesitterParserCMakeLists.txt"
      end

      r.stage(source_directory)
      cp buildpath"cmake.depscmake"cmakelists, source_directory"CMakeLists.txt"

      system "cmake", "-S", source_directory, "-B", build_directory, "-DPARSERLANG=#{parser_name}", *std_cmake_args
      system "cmake", "--build", build_directory
      system "cmake", "--install", build_directory
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

    args = [
      "-DLUV_LIBRARY=#{Formula["luv"].opt_libshared_library("libluv")}",
      "-DLIBUV_LIBRARY=#{Formula["libuv"].opt_libshared_library("libuv")}",
      "-DLPEG_LIBRARY=#{Formula["lpeg"].opt_libshared_library("liblpeg")}",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    refute_match "dirty", shell_output("#{bin}nvim --version")
    (testpath"test.txt").write("Hello World from Vim!!")
    system bin"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+sVimNeovimg", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath"test.txt").read.chomp
  end
end