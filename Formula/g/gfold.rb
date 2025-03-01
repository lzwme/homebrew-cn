class Gfold < Formula
  desc "Help keep track of your Git repositories, written in Rust"
  homepage "https:github.comnickgeracegfold"
  url "https:github.comnickgeracegfoldarchiverefstags2025.2.1.tar.gz"
  sha256 "f4bfb2c69da1f2e1a70713b316c2befef553039bc7248594f8f990115a66cc33"
  license "Apache-2.0"
  head "https:github.comnickgeracegfold.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7bb9ab4516cf303807d550bd93f23554e10f4f4482369d3ab1fbf7506e4a605b"
    sha256 cellar: :any,                 arm64_sonoma:  "56125c3b687ac854b0ffb3bb5b34d0e4c158395b43fa8f86151220322cecd4fb"
    sha256 cellar: :any,                 arm64_ventura: "06169b9151d2bde14a0c1782a1357dafd8d0a0fb51f8673c86c8307e3131df35"
    sha256 cellar: :any,                 sonoma:        "4f809c3dc6027ecf9a95fce8773c9722a249d450c8201ff8d46e6869c7840a21"
    sha256 cellar: :any,                 ventura:       "6aac2335765c4330e3977f8cb185773f99fb065cc4c4f75a28701ec25a1d9b48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512c8665866e3918dc0d2ed50dceea71ec220498e9be5eb33cb249faeda251dc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  conflicts_with "coreutils", because: "both install `gfold` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    mkdir "test" do
      system "git", "config", "--global", "init.defaultBranch", "master"
      system "git", "init"
      Pathname("README").write "Testing"
      system "git", "add", "README"
      system "git", "commit", "-m", "init"
    end

    assert_match "\e[0m\e[32mclean\e[0m (master)", shell_output("#{bin}gfold #{testpath} 2>&1")

    # libgit2 linkage test to avoid using vendored one
    # https:github.comHomebrewhomebrew-corepull125393#issuecomment-1465250076
    linkage_with_libgit2 = (bin"gfold").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."

    assert_match "gfold #{version}", shell_output("#{bin}gfold --version")
  end
end