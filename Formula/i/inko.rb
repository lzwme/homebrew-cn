class Inko < Formula
  desc "Safe and concurrent object-oriented programming language"
  homepage "https:inko-lang.org"
  url "https:releases.inko-lang.org0.18.0.tar.gz"
  sha256 "8ebd2c1d8cb3375b50c4236c39f331fd0942861ebeb30b317ec0f904843b5a26"
  license "MPL-2.0"
  head "https:github.cominko-langinko.git", branch: "main"

  # The upstream website doesn't provide easily accessible version information
  # or link to release tarballs, so we check the release manifest file that
  # the Inko version manager (`ivm`) uses.
  livecheck do
    url "https:releases.inko-lang.orgmanifest.txt"
    regex(^v?(\d+(?:\.\d+)+)$im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e1910a560f1ca9131acedf7ece2f246e59a65aacbf450e818d7b469838f673c"
    sha256 cellar: :any,                 arm64_sonoma:  "27c69734fc92663a20ca689d487d97058eeaaa628592264839d5933501d311f3"
    sha256 cellar: :any,                 arm64_ventura: "c5f4eeabd4fb17588a819fdb8756ab77b86042013e507e85751e1e1688cf4fc6"
    sha256 cellar: :any,                 sonoma:        "8f0c6eac46643a0c8f8259b3535eb4c4500867cacd13d0d6999a5c9c18b61b24"
    sha256 cellar: :any,                 ventura:       "3030ff2f27595331f872bfd15f6a5cd47872462742d0659ac349c863d1775c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd6186c879ba0979dddf982d5d203491da1c9906a7a239fb51466d8921639da3"
  end

  depends_on "coreutils" => :build
  depends_on "rust" => :build
  depends_on "llvm@17" # see https:github.cominko-langinkoblob4738b81dbec1f50dadeec3608dde855583f80ddacimac.sh#L5
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
      import std.stdio (Stdout)

      class async Main {
        fn async main {
          Stdout.new.print('Hello, world!')
        }
      }
    EOS
    assert_equal "Hello, world!\n", shell_output("#{bin}inko run hello.inko")
  end
end