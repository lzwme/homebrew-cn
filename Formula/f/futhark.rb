class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https:futhark-lang.org"
  license "ISC"
  head "https:github.comdiku-dkfuthark.git", branch: "master"

  stable do
    url "https:github.comdiku-dkfutharkarchiverefstagsv0.25.25.tar.gz"
    sha256 "e7bd5e1cecea2ca45be18220c82cb9b717bead314182853cc739c8f68b657a03"

    # Backport support for GHC 9.12
    patch do
      url "https:github.comdiku-dkfutharkcommit6fc96847b2cd4056df4cbdcbdab7f91cac2363fa.patch?full_index=1"
      sha256 "a90f4a6318e3fb96004f91f5c5afb126b36b9021beead2d22be50464c90b5219"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea8d09876633f3270c02b3b5ddb4ece2ea00269524487ef121f487f0ecfc4aca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2771a45b3dcf012339b3813ed9d3231a972c98cd157037ba5d2fdac78d54d8b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70ef09f82573dea44e2cb502da6a40e09d76379aa43bd7e8253a9039af7bef3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "daacba28a9e3585f35457863ae133e45c34173e4ae924c50786d170634ef8947"
    sha256 cellar: :any_skip_relocation, ventura:       "117f0454d59e15cb8eccc1b37854adf28d623175eaa905d0a6ca47b6c56a143c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91de41f78f61b612b11bcafd0e5495b8a6dca6f0b98f7b74adea8df9910821ed"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs_buildman*.1"]
  end

  test do
    (testpath"test.fut").write <<~EOS
      def main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system bin"futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output(".test", "10", 0).chomp
  end
end