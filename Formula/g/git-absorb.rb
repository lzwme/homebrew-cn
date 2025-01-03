class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https:github.comtummychowgit-absorb"
  url "https:github.comtummychowgit-absorbarchiverefstags0.6.16.tar.gz"
  sha256 "d0fac448801674a4d4d5d42d6ef2d2e21545ad66755023c531a273a47893a573"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30bdd79e994ae339882f9d9b758f808a430839e23d8f05cd165a3eca51e9825d"
    sha256 cellar: :any,                 arm64_sonoma:  "633ec7dee3d9e2d67cb769cc40e4d98736ab0c3e3a0bb232462aba861ee47c4e"
    sha256 cellar: :any,                 arm64_ventura: "08385cd180f2c66dea7b196fd73afc5508f6e947f6e4ff3e45b1d2404d8d1b32"
    sha256 cellar: :any,                 sonoma:        "b4b5c9c9f0f3ec884693cae8b837279d0b84cc3ad652598d29427ff22aceaa63"
    sha256 cellar: :any,                 ventura:       "02bc3097f3b59424eab05c5e8df7184fb26896fad8050bdebc76c15324d26748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b65e73c6509e7cf7b4cfb2ca37f28f5d8df9f81859e82e80fd306b79fddb96"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https:github.comrust-langgit2-rsissues1109 to support libgit2 1.9

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
    man1.install "Documentationgit-absorb.1"

    generate_completions_from_executable(bin"git-absorb", "--gen-completions")
  end

  test do
    (testpath".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath"test").delete
    (testpath"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"

    linkage_with_libgit2 = (bin"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.8"].opt_libshared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end