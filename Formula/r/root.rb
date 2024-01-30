class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https:root.cern.ch"
  url "https:root.cern.chdownloadroot_v6.30.02.source.tar.gz"
  sha256 "7965a456d1ad1ee0d5fe4769bf5a8fec291af684ed93db0f3080a9c362435183"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comroot-projectroot.git", branch: "master"

  livecheck do
    url "https:root.cerninstallall_releases"
    regex(%r{Release\s+v?(\d+(?:[.]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "3bc61294329fec1985bb3f4292b7152f0b8569a859b70f35fb147e4def2bad0a"
    sha256 arm64_ventura:  "8246869c9c04d2700bc1572b3f0a3b198e101dbc195765b7fe0eb01fb877d6e1"
    sha256 arm64_monterey: "f9c36bf0517c85d48cca36aa88103d6747c92b9111ff4307b34fd14af272a1f3"
    sha256 sonoma:         "a43bb477504f99102f53e6435d585ffa4a8c19490a9d57eff56bceda2c7acd04"
    sha256 ventura:        "4963c2619981d5e439086d143b3e90f885c8e07a3ad889630b24e7cdec4c0460"
    sha256 monterey:       "e02e24dc8c0deba276bd44bcdf2d6d7bd6f988ce95f3c1380ed35d3ad8a4fd36"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "nlohmann-json"
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on :xcode
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxft"
    depends_on "libxpm"
  end

  skip_clean "bin"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  patch do
    url "https:github.comroot-projectrootcommitd6b6a7371725ad71a0574e7f3c3b4924b99353dd.patch?full_index=1"
    sha256 "9482350c673c461058996af8c0945d3a2c1455af744c01ef655e3737eb9bc46a"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}root"
    ENV.remove "HOMEBREW_INCLUDE_PATHS", Formula["util-linux"].opt_include if OS.mac?

    inreplace "cmakemodulesSearchInstalledSoftware.cmake" do |s|
      # Enforce secure downloads of vendored dependencies. These are
      # checksummed in the cmake file with sha256.
      s.gsub! "http:lcgpackages", "https:lcgpackages"
      # Patch out check that skips using brewed glew.
      s.gsub! "CMAKE_VERSION VERSION_GREATER 3.15", "CMAKE_VERSION VERSION_GREATER 99.99"
    end

    args = std_cmake_args + %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{python3}
      -DXROOTD_ROOT_DIR=#{Formula["xrootd"].opt_prefix}
      -Dbuiltin_afterimage=ON
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
      -Dminuit2=ON
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
    inreplace "buildunixcompiledata.sh", "`type -path $CXX`", ENV.cxx

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
    <<~EOS
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
    EOS
  end

  test do
    (testpath"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS

    # Test ROOT command line mode
    system bin"root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("#{bin}root -l -b -n -q test.C")

    # Test ACLiC
    assert_equal "\nProcessing test.C+...\nHello, world!\n",
                 shell_output("#{bin}root -l -b -n -q test.C+")

    # Test linking
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    EOS
    flags = %w[cflags libs ldflags].map { |f| "$(#{bin}root-config --#{f})" }
    flags << "-Wl,-rpath,#{lib}root"
    shell_output("$(#{bin}root-config --cxx) test.cpp #{flags.join(" ")}")
    assert_equal "Hello, world!\n", shell_output(".a.out")

    # Test Python module
    system python3, "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end