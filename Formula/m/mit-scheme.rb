class MitScheme < Formula
  desc "MITGNU Scheme development tools and runtime library"
  homepage "https:www.gnu.orgsoftwaremit-scheme"
  url "https:ftp.gnu.orggnumit-schemestable.pkg12.1mit-scheme-12.1-svm1-64le.tar.gz"
  mirror "https:ftpmirror.gnu.orggnumit-schemestable.pkg12.1mit-scheme-12.1-svm1-64le.tar.gz"
  sha256 "2c5b5bf1f44c7c2458da79c0943e082ae37f1752c7d9d1ce0a61f7afcbf04304"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https:ftp.gnu.orggnumit-schemestable.pkg?C=M&O=D"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "da2acf2666e321393c150917e783456c04942de61a2b4db2eebfaeaac094168b"
    sha256 arm64_ventura:  "23923b9cbbf60f33e46325ec788edaf149b1d43b62ddd69beff33528b14453c3"
    sha256 arm64_monterey: "cfdb8ea9127c65a67e727fe75c293cde238172a18de91343540ff49c949f8449"
    sha256 sonoma:         "a8ebb5f3d8e66fd9a2924b02bdd0e920e5484890865ea107fdbba9a737dc703c"
    sha256 ventura:        "03ec5e2d199d6736dc7345d4ca3c083a78c53cb024b3874edb0e45aeb7123a2a"
    sha256 monterey:       "72fcee689c1ca44d5834d654490f8368f099e939f4065c4f9f06d24c0022bd19"
    sha256 x86_64_linux:   "0e910ffb8aff109164099832f8d465f54e9e0c731a0580cb0c794970e3f6ce11"
  end

  # Has a hardcoded compile check for ApplicationsXcode.app
  # Dies on "configure: error: SIZEOF_CHAR is not 1" without Xcode.
  # https:github.comHomebrewhomebrew-x11issues103#issuecomment-125014423
  depends_on xcode: :build

  uses_from_macos "m4" => :build
  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  resource "bootstrap" do
    url "https:ftp.gnu.orggnumit-schemestable.pkg12.1mit-scheme-12.1-svm1-64le.tar.gz"
    sha256 "2c5b5bf1f44c7c2458da79c0943e082ae37f1752c7d9d1ce0a61f7afcbf04304"
  end

  def install
    resource("bootstrap").stage do
      cd "src"
      system ".configure", "--prefix=#{buildpath}staging", "--without-x"
      system "make"
      system "make", "install"
    end

    # Liarc builds must launch within the src dir, not using the top-level
    # Makefile
    cd "src"

    # Take care of some hard-coded paths
    %w[
      6001edextra.scm
      6001floppy.scm
      compileretcdisload.scm
      edwintechinfo.scm
      edwinunix.scm
    ].each do |f|
      inreplace f, "usrlocal", prefix
    end

    inreplace "microcodeconfigure" do |s|
      s.gsub! "usrlocal", prefix

      # Fixes "configure: error: No MacOSX SDK for version: 10.10"
      # Reported 23rd Apr 2016: https:savannah.gnu.orgbugsindex.php?47769
      s.gsub!(SDK=MacOSX\$\{MACOS\}$, "SDK=MacOSX#{MacOS.sdk.version}") if OS.mac?
    end

    inreplace "edwincompile.sh" do |s|
      s.gsub! "mit-scheme", bin"mit-scheme"
    end

    ENV.prepend_path "PATH", buildpath"stagingbin"

    system ".configure", "--prefix=#{prefix}", "--mandir=#{man}", "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    # https:www.cs.indiana.edupubscheme-repositorycodenumprimes.scm
    (testpath"primes.scm").write <<~EOS
      ;
      ; primes
      ; By Ozan Yigit
      ;
      (define  (interval-list m n)
        (if (> m n)
            '()
            (cons m (interval-list (+ 1 m) n))))

      (define (sieve l)
        (define (remove-multiples n l)
          (if (null? l)
        '()
        (if  (= (modulo (car l) n) 0)      ; division test
             (remove-multiples n (cdr l))
             (cons (car l)
             (remove-multiples n (cdr l))))))

        (if (null? l)
            '()
            (cons (car l)
            (sieve (remove-multiples (car l) (cdr l))))))

      (define (primes<= n)
        (sieve (interval-list 2 n)))

      ; (primes<= 300)
    EOS

    output = shell_output(
      "#{bin}mit-scheme --load primes.scm --eval '(primes<= 72)' < devnull",
    )
    assert_match(
      ;Value: \(2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71\),
      output,
    )
  end
end