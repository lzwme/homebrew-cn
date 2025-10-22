class Nwchem < Formula
  desc "High-performance computational chemistry tools"
  homepage "https://nwchemgit.github.io"
  url "https://ghfast.top/https://github.com/nwchemgit/nwchem/releases/download/v7.2.3-release/nwchem-7.2.3-release.revision-d690e065-src.2024-08-27.tar.xz"
  version "7.2.3"
  sha256 "7788e6af9be8681e6384b8df4df5ac57d010b2c7aa50842d735c562d92f94c25"
  license "ECL-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)-release$/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "7bdfe1b874aa6788676c26b8fe6632827486a1deb212b31b54376f6c825edc14"
    sha256                               arm64_sequoia: "ca4f6ffb98e1bf637ede7d811ebba58292ec49c4153ae344ed67b1c470087648"
    sha256                               arm64_sonoma:  "24520eae34ff9e5be75493d87487f5282c4005671b57ed26b6caccdaff292dc7"
    sha256 cellar: :any,                 sonoma:        "37267e96f446bb2ac7f11f425ea952c886dd2b01d706279b38e3de8935bfdc3b"
    sha256                               arm64_linux:   "4eb2f27fc6249621cd2e4ff810137f2d4faa268fa9530838a2625d7d98a20d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35139d4173d4a7024e3bbe70d69df306fceecd0b09950cd57b2a4c4bc3cf46c7"
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libxc"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "pkgconf"
  depends_on "python@3.14"
  depends_on "scalapack"

  uses_from_macos "libxcrypt"

  # fix download url in build_dftd3a.sh, upstream pr ref, https://github.com/nwchemgit/nwchem/pull/1054
  patch do
    url "https://github.com/nwchemgit/nwchem/commit/65ce7726d9fa418f7c01665bebfc1e2181f15adf.patch?full_index=1"
    sha256 "13410bdadc51ae60e0f6fb3a1ce4dece8a2c97a19c4e59ee027ea8443b6d3f2f"
  end

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

      inreplace "util/util_nwchemrc.F", "/etc/nwchemrc", etc/"nwchemrc"

      # needed to use python 3.X to skip using default python2
      ENV["PYTHONVERSION"] = Language::Python.major_minor_version "python3.14"
      ENV["BLASOPT"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["LAPACK_LIB"] = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV["BLAS_SIZE"] = "4"
      ENV["SCALAPACK"] = "-L#{Formula["scalapack"].opt_prefix}/lib -lscalapack"
      ENV["SCALAPACK_SIZE"] = "4"
      ENV["USE_64TO32"] = "y"
      ENV["USE_HWOPT"] = "n"
      ENV["OPENBLAS_USES_OPENMP"] = "y"
      ENV["LIBXC_LIB"] = Formula["libxc"].opt_lib.to_s
      ENV["LIBXC_INCLUDE"] = Formula["libxc"].opt_include.to_s
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
      ENV["OMP_NUM_THREADS"] = "1"
      ENV["NWCHEM_TOP"] = testpath
      ENV["NWCHEM_TARGET"] = OS.mac? ? "MACX64" : "LINUX64"
      ENV["NWCHEM_EXECUTABLE"] = bin/"nwchem"
      system "./runtests.mpi.unix", "procs", "0", "dft_he2+", "pyqa3", "prop_mep_gcube", "pspw", "tddft_h2o", "tce_n2"
    end
  end
end