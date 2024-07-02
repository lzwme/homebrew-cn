class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https:inko-lang.org"
  url "https:releases.inko-lang.org0.15.0.tar.gz"
  sha256 "a28205c4776cc87894ef0deb0e7a043d42a790eab913558ad25d27884ffd2006"
  license "MPL-2.0"
  head "https:github.cominko-langinko.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "51a6d9635099eb9183bca841bc8e8eeb1b58bc22095354f4c510913ddc9e0690"
    sha256 cellar: :any,                 arm64_ventura:  "9e48dbcd041065ab6e05cd77bf70b98005f73e8b85eb66dbddd2b92a3f3bebd6"
    sha256 cellar: :any,                 arm64_monterey: "8a1302a1751c5e74a3791aaad462a9c7b976df193964e9a0b257a3a393af994c"
    sha256 cellar: :any,                 sonoma:         "cc72afee9d9e29467f218873235f037e77313179911c73f0c1069bb0ab048a18"
    sha256 cellar: :any,                 ventura:        "67708a7b08d56dfd788604698b060482b937902821484b5dc44b0f6e52a8ccff"
    sha256 cellar: :any,                 monterey:       "c10652b60c03eb4ffb4f62d187a2a3b601449df0ff9ffbf9dc71d9bff85c7d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b152aca6d20dd0e8b33867db08d2129ab72d1785b365d930baad9097f95b5ad"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ncurses"
  uses_from_macos "ruby", since: :sierra
  uses_from_macos "zlib"

  on_macos do
    depends_on "z3"
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].opt_libexec"gnubin"
    system "make", "build", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath"hello.inko").write <<~EOS
      import std.stdio (STDOUT)

      class async Main {
        fn async main {
          STDOUT.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}inko run hello.inko")
  end
end