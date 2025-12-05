class Msolve < Formula
  desc "Library for Polynomial System Solving through Algebraic Methods"
  homepage "https://msolve.lip6.fr"
  url "https://ghfast.top/https://github.com/algebraic-solving/msolve/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "2e46b88b38abbe4e4937ef5fc4a90a006d1ff933ffa7563287b5d756de3bcf6e"
  license "GPL-2.0-or-later"
  head "https://github.com/algebraic-solving/msolve.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b0aa70c0732ac0048cb3107ec3db4475f5929f57dcc3c49713f22a0480a6a2c"
    sha256 cellar: :any,                 arm64_sequoia: "99ad2466d96c0b16c1c57713a1f4c85fc83966c36e0323c0225e1c1b281c2c2f"
    sha256 cellar: :any,                 arm64_sonoma:  "7d4985f4b4c6c9d690ba3016573e2cb7069b4e98de92fbca61500ac9f323ff9a"
    sha256 cellar: :any,                 sonoma:        "5f934578f9ba33d6f74997582ae5bab7dbc3c9a06ccd2881e4201a2d79d4068b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00e46ca26c703121cd75c06b1f6eccd9aa5de02475409999d49870cf436a8823"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc9092239bc318e261fc41cbbc92d703f7c2a9fe36ba79f21a6550c42385017d"
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