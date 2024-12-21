class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https:itk.org"
  url "https:github.comInsightSoftwareConsortiumITKreleasesdownloadv5.3.0InsightToolkit-5.3.0.tar.gz"
  sha256 "57a4471133dc8f76bde3d6eb45285c440bd40d113428884a1487472b7b71e383"
  license "Apache-2.0"
  revision 5
  head "https:github.comInsightSoftwareConsortiumITK.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:  "7e6fa6206a1287a8e41aa8a66866b964400d2323e5d0272fba30be3f94e98bf3"
    sha256                               arm64_ventura: "98e52f5398df15ccc136dd725a50d8b3e544aebe9829fb0dd6296d28da4cf53d"
    sha256                               sonoma:        "14099a14dce6c7ff00da7ddecb42b5f543dfcc53e18e78eb0cea8398b7bd020b"
    sha256                               ventura:       "001226c931a2e1da1a3520d7280b2c5e647655aeea68ca7ee21a2e5ee462950f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d624a275a5943065f01141493a8cc3ab37becaa3e0e5d32bff7fac188e7d2d"
  end

  depends_on "cmake" => :build

  depends_on "double-conversion"
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "glew"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "unixodbc"
  end

  def install
    # Avoid CMake trying to find GoogleTest even though tests are disabled
    rm_r(buildpath"ModulesThirdPartyGoogleTest")

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_LEGACY_REMOVE=ON
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_FFTWF=ON
      -DITK_USE_FFTWD=ON
      -DITK_USE_SYSTEM_FFTW=ON
      -DITK_USE_SYSTEM_HDF5=ON
      -DITK_USE_SYSTEM_JPEG=ON
      -DITK_USE_SYSTEM_PNG=ON
      -DITK_USE_SYSTEM_TIFF=ON
      -DITK_USE_SYSTEM_GDCM=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DITK_USE_SYSTEM_DOUBLECONVERSION=ON
      -DITK_USE_SYSTEM_LIBRARIES=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
      -DModule_SCIFIO=ON
    ]
    # Cannot compile on macOS with this arg
    # Upstream issue: https:github.comInsightSoftwareConsortiumITKissues3821
    # args << "-DITK_USE_GPU=ON" if OS.mac?

    # Avoid references to the Homebrew shims directory
    inreplace "ModulesCoreCommonsrcCMakeLists.txt" do |s|
      s.gsub!(MAKE_MAP_ENTRY\(\s*\\"CMAKE_C_COMPILER\\",
              \s*\\"\${CMAKE_C_COMPILER}\\".*\);x,
              "MAKE_MAP_ENTRY(\\\"CMAKE_C_COMPILER\\\", " \
              "\\\"#{ENV.cc}\\\", \\\"The C compiler.\\\");")

      s.gsub!(MAKE_MAP_ENTRY\(\s*\\"CMAKE_CXX_COMPILER\\",
              \s*\\"\${CMAKE_CXX_COMPILER}\\".*\);x,
              "MAKE_MAP_ENTRY(\\\"CMAKE_CXX_COMPILER\\\", " \
              "\\\"#{ENV.cxx}\\\", \\\"The CXX compiler.\\\");")
    end

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Remove the bundled JRE installed by SCIFIO ImageIO plugin
    rm_r(lib"jre") if OS.linux? || Hardware::CPU.intel?
  end

  test do
    (testpath"test.cxx").write <<~CPP
      #include "itkImage.h"
      int main(int argc, char* argv[])
      {
        typedef itk::Image<unsigned short, 3> ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();
        return EXIT_SUCCESS;
      }
    CPP

    v = version.major_minor
    # Build step
    system ENV.cxx, "-std=c++14", "-isystem", "#{include}ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++14", "test.cxx.o", "-o", "test",
                    libshared_library("libITKCommon-#{v}", 1),
                    libshared_library("libITKVNLInstantiation-#{v}", 1),
                    libshared_library("libitkvnl_algo-#{v}", 1),
                    libshared_library("libitkvnl-#{v}", 1)
    system ".test"
  end
end