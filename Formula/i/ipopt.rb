class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https:coin-or.github.ioIpopt"
  url "https:github.comcoin-orIpoptarchiverefstagsreleases3.14.16.tar.gz"
  sha256 "cc8c217991240db7eb14189eee0dff88f20a89bac11958b48625fa512fe8d104"
  license "EPL-2.0"
  revision 1
  head "https:github.comcoin-orIpopt.git", branch: "stable3.14"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ff6ba93dca47a18218817c81fa1e0f67b950d031fcedae98f33cc291eea6bd34"
    sha256 cellar: :any,                 arm64_sonoma:  "6b2e17f3d29e91fcea03af5de5c51cddfcc3a7a31c6be0686ccee3400a56b7ed"
    sha256 cellar: :any,                 arm64_ventura: "41aae134e8a11bbbd904e625f19dd91b9462bcd47eb245ce0758d2b4580bb6ca"
    sha256 cellar: :any,                 sonoma:        "6f5af16203486282e3eb4d74380600a35544b362d171c66c4161a367ac4c22eb"
    sha256 cellar: :any,                 ventura:       "d042fd4c2993aad8181d9be04ff2ce979f1b9f206c5fe9e5b1638da827caa2b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "563c0669c52d28e3e80c8352f28c48b68e8421036ca0e8a08868b1c97ee9d739"
  end

  depends_on "openjdk" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "ampl-asl"
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  resource "mumps" do
    # follow links provided in official repo: https:github.comcoin-or-toolsThirdParty-Mumpsblobstable3.0get.Mumps
    url "https:coin-or-tools.github.ioThirdParty-MumpsMUMPS_5.6.2.tar.gz"
    mirror "https:deb.debian.orgdebianpoolmainmmumpsmumps_5.6.2.orig.tar.gz"
    sha256 "13a2c1aff2bd1aa92fe84b7b35d88f43434019963ca09ef7e8c90821a8f1d59a"

    patch do
      # MUMPS does not provide a Makefile.inc customized for macOS.
      on_macos do
        url "https:raw.githubusercontent.comHomebrewformula-patchesab96a8b8e510a8a022808a9be77174179ac79e85ipoptmumps-makefile-inc-generic-seq.patch"
        sha256 "0c570ee41299073ec2232ad089d8ee10a2010e6dfc9edc28f66912dae6999d75"
      end

      on_linux do
        url "https:gist.githubusercontent.comdawidd609f831daf608eb6e07cc80286b483030rawb5ab689dea5772e9b6a8b6d88676e8d76224c0ccmumps-homebrew-linux.patch"
        sha256 "13125be766a22aec395166bf015973f5e4d82cd3329c87895646f0aefda9e78e"
      end
    end
  end

  resource "test" do
    url "https:github.comcoin-orIpoptarchiverefstagsreleases3.14.16.tar.gz"
    sha256 "cc8c217991240db7eb14189eee0dff88f20a89bac11958b48625fa512fe8d104"
  end

  resource "miniampl" do
    url "https:github.comdpominiamplarchiverefstagsv1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
  end

  def install
    ENV.delete("MPICC")
    ENV.delete("MPICXX")
    ENV.delete("MPIFC")

    resource("mumps").stage do
      cp "Make.incMakefile.inc.generic.SEQ", "Makefile.inc"
      inreplace "Makefile.inc", "@rpath", "#{opt_lib}" if OS.mac?

      # Fix for GCC 10
      inreplace "Makefile.inc", "OPTF    = -fPIC",
                "OPTF    = -fPIC -fallow-argument-mismatch"

      ENV.deparallelize { system "make", "d" }

      (buildpath"mumps_include").install Dir["include*.h", "libseqmpi.h"]
      lib.install Dir[
        "lib#{shared_library("*")}",
        "libseq#{shared_library("*")}",
        "PORDlib#{shared_library("*")}"
      ]
    end

    args = [
      "--disable-silent-rules",
      "--enable-shared",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-asl"].opt_include}asl",
      "--with-asl-lflags=-L#{Formula["ampl-asl"].opt_lib} -lasl",
    ]

    system ".configure", *args, *std_configure_args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    testpath.install resource("test")
    pkgconf_flags = shell_output("pkgconf --cflags --libs ipopt").chomp.split
    system ENV.cxx, "exampleshs071_cpphs071_main.cpp", "exampleshs071_cpphs071_nlp.cpp", *pkgconf_flags
    system ".a.out"

    resource("miniampl").stage do
      system bin"ipopt", "exampleswb"
    end
  end
end