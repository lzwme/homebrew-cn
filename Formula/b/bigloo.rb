class Bigloo < Formula
  desc "Scheme implementation with object system, C, and Java interfaces"
  homepage "https:www-sop.inria.frindesfpBigloo"
  url "ftp:ftp-sop.inria.frindesfpBigloobigloo-4.5b.tar.gz"
  sha256 "864d525ee6a7ff339fd9a8c973cc46bf9a623a3827d84bfb6e04a29223707da5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https:www-sop.inria.frindesfpBigloodownload.html"
    regex(bigloo-latest\.t.+?\(([^)]+?)\)i)
  end

  bottle do
    sha256 sonoma:       "87f739f5dc22555f9d914efbfaacb4715df51f21bdb44e17f43abe82f4503b5f"
    sha256 ventura:      "b0dd80c2dbea9dd76a2bac9a37b876fd0d038702314703e4533a417395306519"
    sha256 monterey:     "9032ae31c02e46332ac3f6c9a541a8ab254143a9cae1e3af6dcf951e40070455"
    sha256 x86_64_linux: "00415bbace966492d5a38ef6d0c6b650b78fa2df060a334581f2db746a4b4f08"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on arch: :x86_64
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libunistring"
  depends_on "libuv"
  depends_on "openjdk"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "sqlite"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Remove when included in a release:
    # https:github.commanuel-serranobigloocommit8b2a912c7c668a2a0bfa2ec30bc68bfdd05d2d7f
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # Force bigloo not to use vendored libraries
    inreplace "configure", (^\s+custom\w+)=yes$, "\\1=no"

    # configure doesn't respect --mandir or MANDIR
    inreplace "configure", "$prefixmanman1", "$prefixsharemanman1"

    # configure doesn't respect --infodir or INFODIR
    inreplace "configure", "$prefixinfo", "$prefixshareinfo"

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

    if OS.mac?
      args << "--os-macosx"
      args << "--disable-alsa"
    else
      args << "--disable-libbacktrace"
    end

    system ".configure", *args, *std_configure_args

    system "make"
    system "make", "install"

    # Install the other manpages too
    manpages = %w[bgldepend bglmake bglpp bgltags bglafile bgljfile bglmco bglprof]
    manpages.each { |m| man1.install "manuals#{m}.man" => "#{m}.1" }
  end

  test do
    program = <<~EOS
      (display "Hello World!")
      (newline)
      (exit)
    EOS
    assert_match "Hello World!\n", pipe_output("#{bin}bigloo -i -", program)
  end
end