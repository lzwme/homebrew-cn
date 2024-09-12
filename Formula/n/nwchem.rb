class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https:nwchemgit.github.io"
  url "https:github.comnwchemgitnwchemreleasesdownloadv7.2.3-releasenwchem-7.2.3-release.revision-d690e065-src.2024-08-27.tar.xz"
  version "7.2.3"
  sha256 "7788e6af9be8681e6384b8df4df5ac57d010b2c7aa50842d735c562d92f94c25"
  license "ECL-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)-release$i)
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia:  "d86155ac7db5802fadf35c54bd5fdc64189ad7c6186c752ac78f74c214574e73"
    sha256                               arm64_sonoma:   "a75b40c513a6e79f6a32aea09ce30c407df91547a3a515824775ed0597298b4c"
    sha256                               arm64_ventura:  "d38f1ecff266e151d4b78adcf8f945aea1fa29b81201082199de0d827bb701b8"
    sha256                               arm64_monterey: "2e5ac17baa07d607585f98883941fcd3ba9126677b006a43d93389a687644ac0"
    sha256 cellar: :any,                 sonoma:         "1dbfcaa23350cc418b90316f2106a6814a64a1bd86cbec6595b8340a2c337109"
    sha256 cellar: :any,                 ventura:        "8c3742ebeb7f2febbf03f276a87e44734df280057d2541fa24923870398c1568"
    sha256 cellar: :any,                 monterey:       "e3313f92d71ef60e66f60a33f181d59b55a023ed74e2fc49ee710af4ac682b61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beb1a8edd7d819e1ba9a02b08242bcda2179a19dacf729c4dfdb0a249567e699"
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "pkg-config"
  depends_on "python@3.12"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  def install
    pkgshare.install "QA"

    cd "src" do
      (prefix"etc").mkdir
      (prefix"etcnwchemrc").write <<~EOS
        nwchem_basis_library #{pkgshare}libraries
        nwchem_nwpw_library #{pkgshare}libraryps
        ffield amber
        amber_1 #{pkgshare}amber_s
        amber_2 #{pkgshare}amber_q
        amber_3 #{pkgshare}amber_x
        amber_4 #{pkgshare}amber_u
        spce    #{pkgshare}solventsspce.rst
        charmm_s #{pkgshare}charmm_s
        charmm_x #{pkgshare}charmm_x
      EOS

      inreplace "utilutil_nwchemrc.F", "etcnwchemrc", etc"nwchemrc"

      # needed to use python 3.X to skip using default python2
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.12"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}lib -lscalapack"
      ENV["SCALAPACK_SIZE"] = "4"
      ENV["USE_64TO32"] = "y"
      ENV["USE_HWOPT"] = "n"
      ENV["OPENBLAS_USES_OPENMP"] = "y"
      ENV["LIBXC_LIB"] = Formula["libxc"].opt_lib.to_s
      ENV["LIBXC_INCLUDE"] = Formula["libxc"].opt_include.to_s
      os = OS.mac? ? "MACX64" : "LINUX64"
      system "make", "nwchem_config", "NWCHEM_MODULES=all python gwmol", "USE_MPI=Y"
      system "make", "NWCHEM_TARGET=#{os}", "USE_MPI=Y"
      bin.install "..bin#{os}nwchem"
      pkgshare.install "basislibraries"
      pkgshare.install "basislibraries.bse"
      pkgshare.install "nwpwlibraryps"
      pkgshare.install Dir["data*"]
    end
  end

  test do
    cp_r pkgshare"QA", testpath
    cd "QA" do
      ENV["OMP_NUM_THREADS"] = "1"
      ENV["NWCHEM_TOP"] = testpath
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = bin"nwchem"
      system ".runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end