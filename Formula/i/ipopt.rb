class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https://coin-or.github.io/Ipopt/"
  url "https://ghfast.top/https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.18.tar.gz"
  sha256 "a3e94b409871f84487c9f452e85d512848f536a2306bf7c02a3e1c691d77ac6b"
  license "EPL-2.0"
  head "https://github.com/coin-or/Ipopt.git", branch: "stable/3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ffcb18d097246419e403378fe05082940d7cd098925807b63ed06f13fa507a32"
    sha256 cellar: :any,                 arm64_sonoma:  "85b5c0af8c85ef66f1c390e778f0e029ec46b2c228db12200efc00b015990e07"
    sha256 cellar: :any,                 arm64_ventura: "da028da228974183f9f0f82847f7e621a2bb90bc16153eb01368648971620533"
    sha256 cellar: :any,                 sonoma:        "518c4faad34af5a856109efa9aa40af9cffe91c753ef6c2106e6800ee557816e"
    sha256 cellar: :any,                 ventura:       "1cd18f15f5b261a264af7305a5c31e8c03b11d23dccf4b7cb632cce8ac2400f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0551c65260758da75f30ec4c1b00d2932af0681b3aeb82bb798464bc14bf3ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b3f41d9dc6303da2baa7f0692b7f99a250f57c877021b511580f8d385f4100"
  end

  depends_on "openjdk" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "ampl-asl"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    # follow links provided in official repo: https://github.com/coin-or-tools/ThirdParty-Mumps/blob/stable/3.0/get.Mumps
    url "https://coin-or-tools.github.io/ThirdParty-Mumps/MUMPS_5.6.2.tar.gz"
    mirror "https://deb.debian.org/debian/pool/main/m/mumps/mumps_5.6.2.orig.tar.gz"
    sha256 "13a2c1aff2bd1aa92fe84b7b35d88f43434019963ca09ef7e8c90821a8f1d59a"

    patch do
      # MUMPS does not provide a Makefile.inc customized for macOS.
      on_macos do
        url "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/formula-patches/ab96a8b8e510a8a022808a9be77174179ac79e85/ipopt/mumps-makefile-inc-generic-seq.patch"
        sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
      end

      on_linux do
        url "https://ghfast.top/https://gist.githubusercontent.com/dawidd6/09f831daf608eb6e07cc80286b483030/raw/b5ab689dea5772e9b6a8b6d88676e8d76224c0cc/mumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
      end
    end
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.inc/Makefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath/", "#{opt_lib}/" if OS.mac?

      # Fix for GCC 10
      inreplace "Makefile.inc", "OPTF    = -fPIC",
                "OPTF    = -fPIC -fallow-argument-mismatch"

      ENV.deparallelize { system "make", "d" }

      (buildpath/"mumps_include").install Dir["include/*.h", "libseq/mpi.h"]
      lib.install Dir[
        "lib/#{shared_library("*")}",
        "libseq/#{shared_library("*")}",
        "PORD/lib/#{shared_library("*")}",
      ]
    end

    args = [
      "--disable-silent-rules",
      "--enable-shared",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}/mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-asl"].opt_include}/asl",
      "--with-asl-lflags=-L#{Formula["ampl-asl"].opt_lib} -lasl",
    ]

    system "./configure", *args, *std_configure_args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    resource "test" do
      url "https://ghfast.top/https://github.com/coin-or/Ipopt/archive/refs/tags/releases/3.14.18.tar.gz"
      sha256 "a3e94b409871f84487c9f452e85d512848f536a2306bf7c02a3e1c691d77ac6b"
    end

    resource "miniampl" do
      url "https://ghfast.top/https://github.com/dpo/miniampl/archive/refs/tags/v1.0.tar.gz"
      sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
    end

    testpath.install resource("test")
    pkgconf_flags = shell_output("pkgconf --cflags --libs ipopt").chomp.split
    system ENV.cxx, "examples/hs071_cpp/hs071_main.cpp", "examples/hs071_cpp/hs071_nlp.cpp", *pkgconf_flags
    system "./a.out"

    resource("miniampl").stage do
      system bin/"ipopt", "examples/wb"
    end
  end
end