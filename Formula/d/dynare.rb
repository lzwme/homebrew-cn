class Dynare < Formula
  desc "Platform for economic models, particularly DSGE and OLG models"
  homepage "https://www.dynare.org/"
  license "GPL-3.0-or-later"

  # Remove when patch is no longer needed.
  stable do
    url "https://www.dynare.org/release/source/dynare-5.5.tar.xz"
    sha256 "11deae32997e79e500a9802c6408067749485ea7ef3c08bbf24141f2b0e00326"

    on_arm do
      # Needed since we patch a `Makefile.am` below.
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "bison" => :build
      depends_on "flex" => :build

      # Fixes a build error on ARM.
      # Remove the `Hardware::CPU.arm?` in the `autoreconf` call below when this is removed.
      patch do
        url "https://git.dynare.org/Dynare/preprocessor/-/commit/e0c3cb72b7337a5eecd32a77183af9f1609a86ef.diff"
        sha256 "4fe156dce78fba9ec280bceff66f263c3a9dbcd230cc5bac96b5a59c14c7554f"
        directory "preprocessor"
      end
    end
  end

  livecheck do
    url "https://www.dynare.org/download/"
    regex(/href=.*?dynare[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "89af2f9bc6a8a9b3357496f0ea2f0bc8682ead3b89cb3b3ea4ce8811b5140383"
    sha256 cellar: :any,                 arm64_ventura:  "da3560dc7ec52d676c9640720f91f27e557496e1cc7cc933249ca4cb27aea862"
    sha256 cellar: :any,                 arm64_monterey: "fce184e3d71f432ec50abf4b7eeeac93528a7a1ec19e1628441bd4ec715b1244"
    sha256 cellar: :any,                 sonoma:         "43421d8ba5a1df263cbd05d301085cf3e44770a1386c170f65f3f4f501c70248"
    sha256 cellar: :any,                 ventura:        "367357088638ffdd7c3d224d6044531239457e8ae0cc826e78410d741a6f3af5"
    sha256 cellar: :any,                 monterey:       "41ccc196c920038c95a352ba366cb9c7c509a97cc88729f589067f39a0c0b3f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0d4e4bf6b182972101e82a07e91b0f95f64b2615429bd2f822bbc345e5368ef"
  end

  head do
    url "https://git.dynare.org/Dynare/dynare.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
  end

  depends_on "boost" => :build
  depends_on "cweb" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "hdf5"
  depends_on "libmatio"
  depends_on "metis"
  depends_on "octave"
  depends_on "openblas"
  depends_on "suite-sparse"

  resource "slicot" do
    url "https://deb.debian.org/debian/pool/main/s/slicot/slicot_5.0+20101122.orig.tar.gz"
    sha256 "fa80f7c75dab6bfaca93c3b374c774fd87876f34fba969af9133eeaea5f39a3d"
  end

  resource "homebrew-io" do
    url "https://octave.sourceforge.io/download.php?package=io-2.6.4.tar.gz", using: :nounzip
    sha256 "a74a400bbd19227f6c07c585892de879cd7ae52d820da1f69f1a3e3e89452f5a"
  end

  resource "homebrew-statistics" do
    url "https://octave.sourceforge.io/download.php?package=statistics-1.4.3.tar.gz", using: :nounzip
    sha256 "9801b8b4feb26c58407c136a9379aba1e6a10713829701bb3959d9473a67fa05"
  end

  def install
    resource("slicot").stage do
      system "make", "lib", "OPTS=-fPIC", "SLICOTLIB=../libslicot_pic.a",
             "FORTRAN=gfortran", "LOADER=gfortran"
      system "make", "clean"
      system "make", "lib", "OPTS=-fPIC -fdefault-integer-8",
             "FORTRAN=gfortran", "LOADER=gfortran",
             "SLICOTLIB=../libslicot64_pic.a"
      (buildpath/"slicot/lib").install "libslicot_pic.a", "libslicot64_pic.a"
    end

    gcc = Formula["gcc"]

    # GCC is the only compiler supported by upstream
    # https://git.dynare.org/Dynare/dynare/-/blob/master/README.md#general-instructions
    ENV.public_send(:"gcc-#{gcc.any_installed_version.major}") if OS.mac?
    # Prevent superenv from adding `-stdlib=libc++` to compiler invocations.
    ENV.remove "HOMEBREW_CCCFG", "g"

    # Remove `Hardware::CPU.arm?` when the patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose" if build.head? || Hardware::CPU.arm?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-doc",
                          "--disable-matlab",
                          "--with-boost=#{Formula["boost"].prefix}",
                          "--with-gsl=#{Formula["gsl"].prefix}",
                          "--with-matio=#{Formula["libmatio"].prefix}",
                          "--with-slicot=#{buildpath}/slicot"

    # Octave hardcodes its paths which causes problems on GCC minor version bumps
    flibs = "-L#{gcc.opt_lib}/gcc/current -lgfortran -lquadmath -lm"
    system "make", "install", "FLIBS=#{flibs}"
  end

  def caveats
    <<~EOS
      To get started with Dynare, open Octave and type
        addpath #{opt_lib}/dynare/matlab
    EOS
  end

  test do
    ENV.cxx11

    statistics = resource("homebrew-statistics")
    io = resource("homebrew-io")
    testpath.install statistics, io

    cp lib/"dynare/examples/bkk.mod", testpath

    # Replace `makeinfo` with dummy command `true` to prevent generating docs
    # that are not useful to the test.
    (testpath/"dyn_test.m").write <<~EOS
      makeinfo_program true
      pkg prefix #{testpath}/octave
      pkg install io-#{io.version}.tar.gz
      pkg install statistics-#{statistics.version}.tar.gz
      dynare bkk.mod console
    EOS

    system Formula["octave"].opt_bin/"octave", "--no-gui",
           "-H", "--path", "#{lib}/dynare/matlab", "dyn_test.m"
  end
end