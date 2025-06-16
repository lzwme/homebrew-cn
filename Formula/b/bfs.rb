class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https:tavianator.comprojectsbfs.html"
  url "https:github.comtavianatorbfsarchiverefstags4.0.7.tar.gz"
  sha256 "37b11768b9b9bb50c7016d261317a4cd1ce047751681cfad528ccd700a65cd9e"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dcba1d6ff5edd6c47c68f4689c315e828d834055a87913af37028dd0f251179"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d1a1876b5e972cc74ba640fda2fed42bd34d107ef72933603c730c26e4b5ae8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dbeac4b74cf47d565166dd94b1fcf895b16e82a06530058c7d759233a40a8b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3e4aba61a16bbad6d94248347609f5b6d8d8380980b387c3841b2855be81d8d"
    sha256 cellar: :any_skip_relocation, ventura:       "1bf45e3a6083e516c0e60207323c4142735d800febe9c7bfc5093c4b27d031b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3de17f4f074db0cc0357d028f01e68a0b4d2c7341a9f8e4727f7c6cc94c0f1ef"
  end

  depends_on "oniguruma"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1300
  end

  on_linux do
    depends_on "acl"
    depends_on "libcap"
    depends_on "liburing"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1300

    system ".configure", "--enable-release"
    system "make"
    system "make", "install", "DEST_PREFIX=#{prefix}", "DEST_MANDIR=#{man}"
    bash_completion.install share"bash-completioncompletionsbfs"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal ".test_file", shell_output("#{bin}bfs -name 'test*' -depth 1").chomp
  end
end