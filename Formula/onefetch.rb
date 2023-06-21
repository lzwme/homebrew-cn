class Onefetch < Formula
  desc "Command-line Git information tool"
  homepage "https://onefetch.dev/"
  url "https://ghproxy.com/https://github.com/o2sh/onefetch/archive/2.18.0.tar.gz"
  sha256 "9aef1eea18d325d4608d202051e386436e73172c51bb1889ae709efca922fa1e"
  license "MIT"
  head "https://github.com/o2sh/onefetch.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e25fba3cef5a9a30080304eb47d3452db8752a11b06386f915d9e396bb36e2b"
    sha256 cellar: :any,                 arm64_monterey: "ce42b8e5eeb490e8a674d866b3cd3031c8deb878543ed3103a396ff7afa20bd2"
    sha256 cellar: :any,                 arm64_big_sur:  "f41ed7e2b87ef1679f2652f3787ba55ac3ad344c4568ebf57c8a82583977a1ce"
    sha256 cellar: :any,                 ventura:        "a3981549ebb0f353a23da49ad4fc9eff31582d26682a281ed0db141dc17ad6bd"
    sha256 cellar: :any,                 monterey:       "c19645127f6e45ece375bd5f9bc16c83c0b3085f4d160f6af8c83a72ceeea4b5"
    sha256 cellar: :any,                 big_sur:        "0635c0670f4faa190e8400640accaae0d4bd69eb85224e962ac35cf003baf88c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "092bd57a467c6e1cd8ee1612e3c289afdddc405271dd14d5729238fe2b68f905"
  end

  # `cmake` is used to build `zstd` and `zlib`.
  # TODO: See if it is possible to use Homebrew dependencies instead.
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "docs/onefetch.1"
    generate_completions_from_executable(bin/"onefetch", "--generate")
  end

  test do
    system "#{bin}/onefetch", "--help"
    assert_match "onefetch " + version.to_s, shell_output("#{bin}/onefetch -V").chomp

    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"

    (testpath/"main.rb").write "puts 'Hello, world'\n"
    system "git", "add", "main.rb"
    system "git", "commit", "-m", "First commit"
    assert_match("Ruby (100.0 %)", shell_output("#{bin}/onefetch").chomp)

    linkage_with_libgit2 = (bin/"onefetch").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end