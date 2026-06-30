class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://ghfast.top/https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "213caf0d0e19447d0adbc3bc946c03ba5054da79495c207b9cd8577fddf86a4c"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d880b46b5e8e52c377a91571aee3d85b6416848a689aceddf303c39f3907d73"
    sha256 cellar: :any, arm64_sequoia: "e49ce34a0a586bd354625325fa6e84cb0738e359eecce943dbc4705cbe9ef3b3"
    sha256 cellar: :any, arm64_sonoma:  "9c65cb82545ef5aec06617565825946314cc030ea509dbed01abe6a8d436ca3d"
    sha256 cellar: :any, sonoma:        "995e5a109be97098255f76a1c8ab65d044b4fd7f006ba9348b9b830635ac42bc"
    sha256 cellar: :any, arm64_linux:   "a4a4557e4d458719cff4203e3d7a1b29ccffa9e339ba58b84438582a5d473423"
    sha256 cellar: :any, x86_64_linux:  "78d3149a1418df2a99ac83a879c82b13eccc421662d10e36f05604e04be8ccbe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"

  on_macos do
    depends_on "libomp"
  end

  def install
    # avoid unsupported openmp
    if OS.mac?
      libomp = Formula["libomp"]
      ENV.append "CPPFLAGS", "-I#{libomp.opt_include}"
      ENV.append_to_cflags "-Xpreprocessor -fopenmp"
      ENV.append "LDFLAGS", "-L#{libomp.opt_lib} -lomp"
    end

    # only compile with cpu baseline features for the pre-built binaries
    inreplace "configure.ac", /AX_EXT/, " " if build.bottle?
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--enable-openmp=yes", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"eco10-31.ms").write <<-EOS
      x0,x1,x2,x3,x4,x5,x6,x7,x8,x9
      1073741827
      x0*x1*x9+x1*x2*x9+x2*x3*x9+x3*x4*x9+x4*x5*x9+x5*x6*x9+x6*x7*x9+x7*x8*x9+x0*x9-1,
      x0*x2*x9+x1*x3*x9+x2*x4*x9+x3*x5*x9+x4*x6*x9+x5*x7*x9+x6*x8*x9+x1*x9-2,
      x0*x3*x9+x1*x4*x9+x2*x5*x9+x3*x6*x9+x4*x7*x9+x5*x8*x9+x2*x9-3,
      x0*x4*x9+x1*x5*x9+x2*x6*x9+x3*x7*x9+x4*x8*x9+x3*x9-4,
      x0*x5*x9+x1*x6*x9+x2*x7*x9+x3*x8*x9+x4*x9-5,
      x0*x6*x9+x1*x7*x9+x2*x8*x9+x5*x9-6,
      x0*x7*x9+x1*x8*x9+x6*x9-7,
      x0*x8*x9+x7*x9-8,
      x8*x9-9,
      x0+x1+x2+x3+x4+x5+x6+x7+x8+1
    EOS
    system bin/"msolve", "-f", "eco10-31.ms"
  end
end