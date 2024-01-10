class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https:inko-lang.org"
  url "https:releases.inko-lang.org0.13.2.tar.gz"
  sha256 "3f188a4a2242c61624081d757b66281ba0f0cfb193ebb590f1470f1f6400f773"
  license "MPL-2.0"
  revision 1
  head "https:github.cominko-langinko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5a644c49be988a9c4728b5ad0e0f78d9a94fcaaacc331fca97096aa5ef5eb006"
    sha256 cellar: :any,                 arm64_ventura:  "d7db49e295226d3c2eaaa22dfddb70ce4a5fc4d6cad6a67bfc62bc61de097ecc"
    sha256 cellar: :any,                 arm64_monterey: "3fd8156828c7c22b46e6b0379ef4b3d1a9d7e8494557c7df1f7373f6af827865"
    sha256 cellar: :any,                 sonoma:         "f75c6d1aa1cb492ef0def2e3a5260bccf57e53821c513fff43d74b460482cbcf"
    sha256 cellar: :any,                 ventura:        "5be42c531af1e8bf4dcb4ef3b3001c68e947ed46f9f295d3a896c70af21d3262"
    sha256 cellar: :any,                 monterey:       "907805b569a11e207c79f2e381446dbe83af025689cb90af2d2f3351cb83b6fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff65cc72be87c8fdba4ce8c074498e4811e9946ee0ccf65abdb53ec043d4d9e9"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "llvm@15"
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :sierra

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"hello.inko").write <<~EOS
      import std.stdio.STDOUT

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}inko run hello.inko")
  end
end