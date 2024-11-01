class Ipopt < Formula
  desc "Interior point optimizer"
  homepage "https:coin-or.github.ioIpopt"
  url "https:github.comcoin-orIpoptarchiverefstagsreleases3.14.16.tar.gz"
  sha256 "cc8c217991240db7eb14189eee0dff88f20a89bac11958b48625fa512fe8d104"
  license "EPL-2.0"
  head "https:github.comcoin-orIpopt.git", branch: "stable3.14"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "f27c151e814d4c9a0caeb33bb0a584c5d885121ec6a70a0586b330b8485779fa"
    sha256 cellar: :any,                 arm64_sonoma:  "9a7c783b3ccd11860b615afc874ead0f60700a7f97dde4d5752a4444778aa86d"
    sha256 cellar: :any,                 arm64_ventura: "5e623167a75d4f3516f6e2b50c61578bd3222f18c63abb7d5483c95dd2a0c53b"
    sha256 cellar: :any,                 sonoma:        "fb86b1e3c17ed6cfb6b44bf1fcaca4a989a62335b364baa36490b4f0003675b8"
    sha256 cellar: :any,                 ventura:       "467af1d0edd4ee1beb1ef2496bf277992988c8599b3082467f5be3d6891cd85b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e2c7ebb501bd2b73e5c847f1f5e82dcedfd3a9528de22c6848e9393cedaede6"
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "ampl-mp"
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
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-shared",
      "--prefix=#{prefix}",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-mumps-cflags=-I#{buildpath}mumps_include",
      "--with-mumps-lflags=-L#{lib} -ldmumps -lmpiseq -lmumps_common -lopenblas -lpord",
      "--with-asl-cflags=-I#{Formula["ampl-mp"].opt_include}asl",
      "--with-asl-lflags=-L#{Formula["ampl-mp"].opt_lib} -lasl",
    ]

    system ".configure", *args
    system "make"

    ENV.deparallelize
    system "make", "install"
  end

  test do
    testpath.install resource("test")
    pkg_config_flags = shell_output("pkg-config --cflags --libs ipopt").chomp.split
    system ENV.cxx, "exampleshs071_cpphs071_main.cpp", "exampleshs071_cpphs071_nlp.cpp", *pkg_config_flags
    system ".a.out"

    resource("miniampl").stage do
      system bin"ipopt", "exampleswb"
    end
  end
end