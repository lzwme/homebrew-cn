class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://ghfast.top/https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "742e84cf4d11eeadf62002623ecb7658e5d6d8c838fcf571fac06acf44252983"
  license "GPL-2.0-or-later"
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "45b8916bde31d186d803a2f2cfbd4869eed278d385c7cb3a97c1da631b191cb9"
    sha256 cellar: :any,                 arm64_sonoma:  "958bcf80903400ad1d71d0869f0a42eaf93867624f19cb756a6ea0b432872ec6"
    sha256 cellar: :any,                 arm64_ventura: "4ed81d00c905b6996bea06d2731e89ee570c4ae3efa66b0de3b074f5ee97343d"
    sha256 cellar: :any,                 sonoma:        "9fb2c5a3b264cd2259003b5e6b099bdea903f1c13d425e2a0308e540ea55f239"
    sha256 cellar: :any,                 ventura:       "071188370774cd208aa2749f1613a97adaa88ba1b2322acea7d44c4e032bf553"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a5e176cae3364043adeefbe5b107defb8ffa278b00e1ca750f914f0084751c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac11243d5470405652ba4f49740ef64a3b171f8fa92f5e4dd56d7027d2f4100"
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

    # only compile with cpu baseline features
    inreplace "configure.ac", /AX_EXT/, " "
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