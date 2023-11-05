class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://ghproxy.com/https://github.com/nwchemgit/nwchem/releases/download/v7.2.2-release/nwchem-7.2.2-release.revision-74936fb9-src.2023-11-03.tar.xz"
  version "7.2.2"
  sha256 "037e8c80a946683d10f995a4b5eff7d8247b3c28cf1158f8f752fd2cb49227c5"
  license "ECL-2.0"

  livecheck do
    url "https://github.com/nwchemgit/nwchem.git"
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "59513c595c4891cd95f6fc111c2c72bfe305df49a38d4bcb148b051d67928478"
    sha256                               arm64_ventura:  "0c81255a436816eb8606af03c76d0a304c67facb33a37f0527a71297b6ed12c8"
    sha256                               arm64_monterey: "3009e76fe7d952d088587827cfa4b16a3c3078db4b49b694f9e446e44d5df5cf"
    sha256 cellar: :any,                 sonoma:         "162106bc0c8bb2834b67020c9aef14684e1e43f8c14e9fd3227663548ce39205"
    sha256 cellar: :any,                 ventura:        "a3be3c6add57666927098bc588f1cd2f220683aac7c072d68f52ab4da2c12d39"
    sha256 cellar: :any,                 monterey:       "01b272dc13e01b818b6efa15bd3fe880812d7d4020e280fd1be992ec3860184b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a347320207365efa65024cbf31e7da21c4fedefeda38627814f9d0dfc17c878c"
  end

  depends_on "gcc" # for gfortran
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "python@3.12"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  def install
    pkgshare.install "QA"

    cd "src" do
      (prefix/"etc").mkdir
      (prefix/"etc/nwchemrc").write <<~EOS
        nwchem_basis_library #{pkgshare}/libraries/
        nwchem_nwpw_library #{pkgshare}/libraryps/
        ffield amber
        amber_1 #{pkgshare}/amber_s/
        amber_2 #{pkgshare}/amber_q/
        amber_3 #{pkgshare}/amber_x/
        amber_4 #{pkgshare}/amber_u/
        spce    #{pkgshare}/solvents/spce.rst
        charmm_s #{pkgshare}/charmm_s/
        charmm_x #{pkgshare}/charmm_x/
      EOS

      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", "#{etc}/nwchemrc"

      # needed to use python 3.X to skip using default python2
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.12"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["SCALAPACK_SIZE"] = "4"
      ENV["USE_64TO32"] = "y"
      ENV["USE_HWOPT"] = "n"
      ENV["LIBXC_LIB"] = Formula["libxc"].opt_lib.to_s
      ENV["LIBXC_INCLUDE"] = Formula["libxc"].opt_include.to_s
      ENV.append "OMPI_FCFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
      ENV.append "OMPI_CFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
      os = OS.mac? ? "MACX64" : "LINUX64"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python gwmol", "USE_MPI=Y"
      system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"

      bin.install "../bin/#{os}/nwchem"
      pkgshare.install "basis/libraries"
      pkgshare.install "basis/libraries.bse"
      pkgshare.install "nwpw/libraryps"
      pkgshare.install Dir["data/*"]
    end
  end

  test do
    cp_r pkgshare/"QA", testpath
    cd "QA" do
      ENV["NWCHEM_TOP"] = testpath
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = "#{bin}/nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end