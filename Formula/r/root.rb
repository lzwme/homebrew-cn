class Root < Formula
  desc "Analyzing petabytes of data, scientifically"
  homepage "https:root.cern"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  stable do
    url "https:root.cerndownloadroot_v6.34.06.source.tar.gz"
    sha256 "a799d632dae5bb1ec87eae6ebc046a12268c6849f2a8837921c118fc51b6cff3"

    # Backport unbundling of libraries on macOS
    patch do
      url "https:github.comroot-projectrootcommit73054b434996a530bfd0669d4ef5c1767a93ef70.patch?full_index=1"
      sha256 "430c1e8aeafe5db1bd4298db27e1aecf903ad7f630465551e66ba70868747293"
    end

    # Apply fix for building with macOS 15.4, https:github.comroot-projectrootpull18243
    patch do
      url "https:github.comroot-projectrootcommit0c3644b47f9dd59d33dffa6467275accd9824468.patch?full_index=1"
      sha256 "5b2e8cc151e945cb46e60a1654f4ea3bc51477ae6b1485e8eda22674dd287875"
    end
    patch do
      url "https:github.comroot-projectrootcommit7952c382eee83f222d724d43946ac6b9a7ffe486.patch?full_index=1"
      sha256 "7214cf81275838cc95086c2d6828f661a85c467f2bf424dfc025585b7979a946"
    end
  end

  livecheck do
    url "https:root.cerninstallall_releases"
    regex(%r{Release\s+v?(\d+(?:[.]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "35e3f2a154030e3b5b6d3b58292ead50b140ca502dc2e9fe002e3cd73aadfc34"
    sha256 arm64_sonoma:  "c21ad5487dc64c403d03525aca64868a4794e32aa3fbbd2c10a61adf42138005"
    sha256 arm64_ventura: "187de4ce65fbd6abf027647935fabfe7aee007a71f1e97655b8df76619a3ef3a"
    sha256 sonoma:        "973502e0ff6483aa5ded98a134bf8e68b006eeaf68d0890d1cdf34a761d70a85"
    sha256 ventura:       "858e267200bdacbea023a60628ecb69341931aa8a2640861f6d25169d0e84876"
    sha256 x86_64_linux:  "cb65cef8eab49c4c5186b4f5ad6460a370246440aa6f7ada291de40839e913ca"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc" # for gfortran
  depends_on "giflib"
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "lz4"
  depends_on "mariadb-connector-c"
  depends_on "nlohmann-json"
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "pcre2"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on :xcode
  end

  on_linux do
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxft"
    depends_on "libxpm"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  skip_clean "bin"

  def python3
    "python3.13"
  end

  def install
    # Workaround for CMake 4 due to VDT, https:github.comdpiparovdtblobmasterCMakeLists.txt
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https:github.comHomebrewhomebrew-coreissues135714
    # Related: https:github.comroot-projectclingissues457
    if OS.mac? && MacOS.version > :ventura
      inreplace "interpreterclinglibInterpreterCMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'
    end

    inreplace "cmakemodulesSearchInstalledSoftware.cmake" do |s|
      # Enforce secure downloads of vendored dependencies. These are
      # checksummed in the cmake file with sha256.
      s.gsub! "http:lcgpackages", "https:lcgpackages"
      # Patch out check that skips using brewed glew.
      s.gsub! "CMAKE_VERSION VERSION_GREATER 3.15", "CMAKE_VERSION VERSION_GREATER 99.99"
    end

    args = %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DXROOTD_ROOT_DIR=#{Formula["xrootd"].opt_prefix}
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_clang=ON
      -Dbuiltin_cling=ON
      -Dbuiltin_cppzmq=OFF
      -Dbuiltin_davix=OFF
      -Dbuiltin_fftw3=OFF
      -Dbuiltin_freetype=OFF
      -Dbuiltin_ftgl=OFF
      -Dbuiltin_gl2ps=OFF
      -Dbuiltin_glew=OFF
      -Dbuiltin_gsl=OFF
      -Dbuiltin_llvm=ON
      -Dbuiltin_lz4=OFF
      -Dbuiltin_lzma=OFF
      -Dbuiltin_nlohmannjson=OFF
      -Dbuiltin_openssl=OFF
      -Dbuiltin_openui5=ON
      -Dbuiltin_pcre=OFF
      -Dbuiltin_tbb=OFF
      -Dbuiltin_unuran=OFF
      -Dbuiltin_vc=OFF
      -Dbuiltin_vdt=ON
      -Dbuiltin_veccore=OFF
      -Dbuiltin_xrootd=OFF
      -Dbuiltin_xxhash=OFF
      -Dbuiltin_zeromq=OFF
      -Dbuiltin_zlib=OFF
      -Dbuiltin_zstd=OFF
      -Dcfitsio=ON
      -Ddavix=ON
      -Ddev=OFF
      -Dfail-on-missing=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dfreetype=ON
      -Dgdml=ON
      -Dgfal=OFF
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dmysql=ON
      -Docaml=OFF
      -Doracle=OFF
      -Dpgsql=OFF
      -Dpyroot=ON
      -Dpythia6=OFF
      -Dpythia8=OFF
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dvdt=ON
      -Dxrootd=ON
      -GNinja
    ]

    # Workaround the shim directory being embedded into the output
    inreplace "cmakeunixcompiledata.sh", "`type -path $CXX`", ENV.cxx

    # Homebrew now sets CMAKE_INSTALL_LIBDIR to lib, which is incorrect
    # for ROOT with gnuinstall, so we set it back here.
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args(install_libdir: "libroot")
    system "cmake", "--build", "builddir"
    system "ctest", "-R", "tutorial-tree", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "builddir"
    system "cmake", "--install", "builddir"

    chmod 0755, bin.glob("*.*sh")

    pth_contents = "import site; site.addsitedir('#{lib}root')\n"
    (prefixLanguage::Python.site_packages(python3)"homebrew-root.pth").write pth_contents
  end

  def caveats
    <<~TEXT
      As of ROOT 6.22, you should not need the thisroot scripts; but if you
      depend on the custom variables set by them, you can still run them:

      For bash users:
        . #{HOMEBREW_PREFIX}binthisroot.sh
      For zsh users:
        pushd #{HOMEBREW_PREFIX} >devnull; . binthisroot.sh; popd >devnull
      For cshtcsh users:
        source #{HOMEBREW_PREFIX}binthisroot.csh
      For fish users:
        . #{HOMEBREW_PREFIX}binthisroot.fish
    TEXT
  end

  test do
    (testpath"test.C").write <<~CPP
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    CPP

    # Test ROOT command line mode
    system bin"root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("#{bin}root -l -b -n -q test.C")

    # Test ACLiC
    assert_equal "\nProcessing test.C+...\nHello, world!\n",
                 shell_output("#{bin}root -l -b -n -q test.C+")

    # Test linking
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    CPP
    flags = %w[cflags libs ldflags].map { |f| "$(#{bin}root-config --#{f})" }
    flags << "-Wl,-rpath,#{lib}root"
    shell_output("$(#{bin}root-config --cxx) test.cpp #{flags.join(" ")}")
    assert_equal "Hello, world!\n", shell_output(".a.out")

    # Test Python module
    system python3, "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end