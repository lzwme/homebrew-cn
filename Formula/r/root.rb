class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https:root.cern"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:github.comroot-projectroot.git", branch: "master"

  stable do
    url "https:root.cerndownloadroot_v6.32.06.source.tar.gz"
    sha256 "3fc032d93fe848dea5adb1b47d8f0a86279523293fee0aa2b3cd52a1ffab7247"

    # Backport fix for RPATH on macOS
    patch do
      url "https:github.comroot-projectrootcommit0569d5d7bfb30d96e06c4192658aed4b78e4da64.patch?full_index=1"
      sha256 "24553b16f66459fe947d192854f5fa6832c9414cc711d7705cb8e8fa67d2d935"
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
    sha256 arm64_sequoia: "926049db01a7ba8784d2ccb58368a409774f1803f3fdecfed00d845dc872876e"
    sha256 arm64_sonoma:  "e9d3d3ec4704e77d3a0b4919c00908d24e2e18499baacf2fe3c59b4d8fbfb92e"
    sha256 arm64_ventura: "183f8e23efa428d1ab963447749230cf2b473a2d3483ffb2709773e8c66b466f"
    sha256 sonoma:        "7a1c2f98c12ed6c44ffbd51b036cedc148ffeb4285b3fc3af8a4ad6586d0601b"
    sha256 ventura:       "a2c498026129e235b03c73b3014d70f36f9c06ab05f0cbfbdbf135c9dce283e9"
    sha256 x86_64_linux:  "2b583335b3a904ccb20baf36e41887fb950acf0674f820e10b5fe6b025cfb39f"
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

  on_linux do
    depends_on "giflib"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libtiff"
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
    # Skip modification of CLING_OSX_SYSROOT to the unversioned SDK path
    # Related: https:github.comHomebrewhomebrew-coreissues135714
    # Related: https:github.comroot-projectclingissues457
    inreplace "interpreterclinglibInterpreterCMakeLists.txt", '"MacOSX[.0-9]+\.sdk"', '"SKIP"'

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

    compiledata = if build.head?
      "cmakeunixcompiledata.sh"
    else
      args << "-Dbuiltin_afterimage=ON"
      "buildunixcompiledata.sh"
    end
    # Workaround the shim directory being embedded into the output
    inreplace compiledata, "`type -path $CXX`", ENV.cxx

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
    (testpath"test.C").write <<~C
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    C

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