class Neovim < Formula
  desc "Ambitious Vim-fork focused on extensibility and agility"
  homepage "https://neovim.io/"
  license "Apache-2.0"
  revision 1
  compatibility_version 1
  head "https://github.com/neovim/neovim.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/neovim/neovim/archive/refs/tags/v0.12.5.tar.gz"
    sha256 "a810c95332317bd0017e1ca07e376a8472c79075cbed00fa3737d190a8a0a45a"

    # Keep resources updated according to:
    # https://github.com/neovim/neovim/blob/v#{version}/cmake.deps/deps.txt

    # TODO: Consider shipping these as separate formulae instead. See discussion at
    #       https://github.com/orgs/Homebrew/discussions/3611
    # NOTE: The `fetch` method assumes that the parser name follows the final `-`.
    #       Please name the resources accordingly.
    resource "tree-sitter-c" do
      url "https://ghfast.top/https://github.com/tree-sitter/tree-sitter-c/archive/refs/tags/v0.24.1.tar.gz"
      sha256 "25dd4bb3dec770769a407e0fc803f424ce02c494a56ce95fedc525316dcf9b48"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter/tree-sitter-c/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-lua" do
      url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-lua/archive/refs/tags/v0.5.0.tar.gz"
      sha256 "cf01b93f4b61b96a6d27942cf28eeda4cbce7d503c3bef773a8930b3d778a2d9"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-lua/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-vim" do
      url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/refs/tags/v0.8.1.tar.gz"
      sha256 "93cafb9a0269420362454ace725a118ff1c3e08dcdfdc228aa86334b54d53c2a"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-vim/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-vimdoc" do
      url "https://ghfast.top/https://github.com/neovim/tree-sitter-vimdoc/archive/refs/tags/v4.1.0.tar.gz"
      sha256 "020e8f117f648c8697fca967995c342e92dbd81dab137a115cc7555207fbc84f"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/neovim/tree-sitter-vimdoc/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-query" do
      url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-query/archive/refs/tags/v0.8.0.tar.gz"
      sha256 "c2b23b9a54cffcc999ded4a5d3949daf338bebb7945dece229f832332e6e6a7d"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-query/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end

    resource "tree-sitter-markdown" do
      url "https://ghfast.top/https://github.com/tree-sitter-grammars/tree-sitter-markdown/archive/refs/tags/v0.5.3.tar.gz"
      sha256 "df845b1ab7c7c163ec57d7fa17170c92b04be199bddab02523636efec5224ab6"

      livecheck do
        url "https://ghfast.top/https://raw.githubusercontent.com/neovim/neovim/refs/tags/v#{LATEST_VERSION}/cmake.deps/deps.txt"
        regex(%r{https://github\.com/tree-sitter-grammars/tree-sitter-markdown/archive/v?(\d+(?:\.\d+)+)\.tar\.gz}i)
      end
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "1b7f55232d3aa6e506283ebd392a403bf175af08854028263cda628b4cf04295"
    sha256 arm64_tahoe:       "10376b87b3bca77e04634d2ba06cfe9f99508921cf4afa6533598d34038da1d4"
    sha256 arm64_sequoia:     "c329fd86c2bd1fd5c769d59d5884a051547879ee004bacc5e17cfc77ec647806"
    sha256 arm64_linux:       "3aa9da187f97261d75b2cb48b98c68f65e340e0c64a348554dfc06579358b443"
    sha256 x86_64_linux:      "e5d06f458aa248746374f702bbe4221d2422b453b766f9914fa77be3d05bc967"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "libuv"
  depends_on "lpeg"
  depends_on "luajit"
  depends_on "luv"
  depends_on "tree-sitter"
  depends_on "unibilium"
  depends_on "utf8proc"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def fetch
    resources.each do |r|
      r.stage(buildpath/"deps-build/build/src/treesitter_#{r.name.split("-").last}")
    end

    (buildpath/"fetch-parsers.cmake").write <<~CMAKE
      set_property(DIRECTORY PROPERTY EP_STEP_TARGETS download)
      cmake_language(DEFER CALL get_property targets DIRECTORY PROPERTY BUILDSYSTEM_TARGETS)
      cmake_language(DEFER CALL list FILTER targets INCLUDE REGEX "-download$")
      cmake_language(DEFER CALL add_custom_target download DEPENDS ${targets})
    CMAKE
    system "cmake", "-S", "cmake.deps", "-B", "deps-build",
                    "-DUSE_BUNDLED=OFF", "-DUSE_BUNDLED_TS_PARSERS=ON", "-DCMAKE_TLS_VERIFY=ON",
                    "-DUSE_EXISTING_SRC_DIR=#{build.stable? ? "ON" : "OFF"}",
                    "-DCMAKE_PROJECT_INCLUDE=#{buildpath}/fetch-parsers.cmake", *std_cmake_args
    system "cmake", "--build", "deps-build", "--target", "download"
  end

  def install
    system "cmake", "--build", "deps-build"
    (lib/"nvim/parser").install (buildpath/"deps-build/usr/lib/nvim/parser").children

    # Point system locations inside `HOMEBREW_PREFIX`.
    inreplace "src/nvim/os/stdpaths.c" do |s|
      s.gsub! "/etc/xdg/", "#{etc}/xdg/:\\0"

      if HOMEBREW_PREFIX.to_s != HOMEBREW_DEFAULT_PREFIX
        s.gsub! "/usr/local/share/:/usr/share/", "#{HOMEBREW_PREFIX}/share/:\\0"
      end
    end

    # Replace `-dirty` suffix in `--version` output with `-Homebrew`.
    inreplace "cmake/GenerateVersion.cmake", "--dirty", "--dirty=-Homebrew"

    system "cmake", "-S", ".", "-B", "build",
                    "-DLUV_LIBRARY=#{formula_opt_lib("luv")/shared_library("libluv")}",
                    "-DLIBUV_LIBRARY=#{formula_opt_lib("libuv")/shared_library("libuv")}",
                    "-DLPEG_LIBRARY=#{formula_opt_lib("lpeg")/shared_library("liblpeg")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    refute_match "dirty", shell_output("#{bin}/nvim --version")
    (testpath/"test.txt").write("Hello World from Vim!!")
    system bin/"nvim", "--headless", "-i", "NONE", "-u", "NONE",
                       "+s/Vim/Neovim/g", "+wq", "test.txt"
    assert_equal "Hello World from Neovim!!", (testpath/"test.txt").read.chomp
  end
end