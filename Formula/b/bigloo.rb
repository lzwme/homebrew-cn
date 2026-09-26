class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https://www-sop.inria.fr/indes/fp/Bigloo/"
  url "https://www-sop.inria.fr/indes/fp/Bigloo/download/bigloo-4.7b.tar.gz"
  sha256 "06271cc3da5c164d7fb4a5dc29c442f13d4f4b48319e63c40f8bfa12dc39f22c"
  license "GPL-2.0-or-later"
  head "https://github.com/manuel-serrano/bigloo.git", branch: "master"

  livecheck do
    url "https://www-sop.inria.fr/indes/fp/Bigloo/download/"
    regex(/href=.*?bigloo-(\d+(?:\.\d+)*[a-z]?(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "751e577ca8ec64e2d1a7d9dd107e490b72a8cae551210ed4984908ce6b39a952"
    sha256 arm64_tahoe:       "3483652e2903ad8d176ef988714de839533331989bc9a46fd264b6eaf5dcbcee"
    sha256 arm64_sequoia:     "aa651cb6ee7ae955c9b4a1eaa6857f0e2f397802f540e24969b34dcdee9f3d2f"
    sha256 arm64_linux:       "d7693040966269426692365c78b27246d5a2ef5e0a23afcadc52a583a8dc8b63"
    sha256 x86_64_linux:      "9177720e3971e598efbbb8c9f0e1360cdc05248ba19606d3f7063f2f7b6ee9d8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  # configure runs `java -noverify`, which JDK 27 removed
  # https://github.com/manuel-serrano/bigloo/pull/157
  depends_on "openjdk@25"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  uses_from_macos "zip" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Force bigloo not to use vendored libraries
    inreplace "configure", /(^\s+custom\w+)=yes$/, "\\1=no"

    # configure doesn't respect --mandir or MANDIR
    inreplace "configure", "$prefix/man/man1", "$prefix/share/man/man1"

    # configure doesn't respect --infodir or INFODIR
    inreplace "configure", "$prefix/info", "$prefix/share/info"

    args = %w[
      --customgc=no
      --customgmp=no
      --customlibuv=no
      --customunistring=no
      --native=yes
      --disable-mpg123
      --disable-flac
      --jvm=yes
    ]
    # Record the keg-only JDK so the JVM backend does not depend on `PATH`
    args << "--javaprefix=#{formula_opt_bin("openjdk@25")}"

    if OS.mac?
      args << "--os-macosx"
      args << "--disable-alsa"
    else
      args << "--disable-libbacktrace"
    end

    # configure reads the Java version from the first line of `javac -version`, which `_JAVA_OPTIONS` pushes down
    with_env(_JAVA_OPTIONS: nil) { system "./configure", *args, *std_configure_args }
    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals/#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~SCHEME
      (display "Hello World!")
      (newline)
      (exit)
    SCHEME
    assert_match "Hello World!\n", pipe_output("#{bin}/bigloo -i -", program, 0)
  end
end