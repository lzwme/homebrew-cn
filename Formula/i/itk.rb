class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https:itk.org"
  url "https:github.comInsightSoftwareConsortiumITKreleasesdownloadv5.4.2InsightToolkit-5.4.2.tar.gz"
  sha256 "906e60577c95e0bbf51f661af894b5b16663606e39565c4854c803bc98b13e7d"
  license "Apache-2.0"
  head "https:github.comInsightSoftwareConsortiumITK.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sonoma:  "4cdab3fc218d9073814fa111b2fa434738981b433b03fd8c7b8ca6cb969bb932"
    sha256                               arm64_ventura: "e1ffd71aac3e9b767f7bedc685ba53bb33b4b23379a7dfbe839c1c0c27bd46b6"
    sha256                               sonoma:        "ca84a390943ce24336cacc8e4f84ae22988a85837dd19f3ac9eebdf728a7c577"
    sha256                               ventura:       "1b987f32ae3408d273878e8e9b3f415e6b5f2afab2445cc1b664707193b97922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab73b637c9c35e1e2e54bb49b18ead595facfd12b343148be742dec3cf63608b"
  end

  depends_on "cmake" => :build

  depends_on "double-conversion"
  depends_on "expat"
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"

  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
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
    system ENV.cxx, "-std=c++17", "-isystem", "#{include}ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++17", "test.cxx.o", "-o", "test",
                    libshared_library("libITKCommon-#{v}", 1),
                    libshared_library("libITKVNLInstantiation-#{v}", 1),
                    libshared_library("libitkvnl_algo-#{v}", 1),
                    libshared_library("libitkvnl-#{v}", 1)
    system ".test"
  end
end