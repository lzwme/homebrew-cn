class Bullet < Formula
  desc "Physics SDK"
  homepage "https:bulletphysics.org"
  url "https:github.combulletphysicsbullet3archiverefstags3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  head "https:github.combulletphysicsbullet3.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "662d4ba26dda7fca5cc9395a5d37f2e3292625b30d8b59dfd1379601e88cd9c8"
    sha256 cellar: :any,                 arm64_sonoma:  "731fc08c5bb5c2f25f38154efe84b7520dc2d1b1e35474e1fff8f30366705870"
    sha256 cellar: :any,                 arm64_ventura: "436404c3482bc1f3504848777c33607fe6437022fb4bba4e588f6863c2a64f3d"
    sha256 cellar: :any,                 sonoma:        "9d06bf5b6f1cbc13ea673d69a87d1295b19b326d234c0b2de9a2850f7390f2a2"
    sha256 cellar: :any,                 ventura:       "0f397505429015eb2c5583f263a337e2d29397726f31967576338fcd2b9420c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c961f4a89d4d40e482459cf17731aa3d22b9bae975b968d9e65ad38097659bde"
  end

  depends_on "cmake" => :build
  depends_on "numpy" => [:build, :test]
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => [:build, :test]

  def python3
    "python3.12"
  end

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https:github.combulletphysicsbullet3pull4243
    ENV.cxx11 if OS.linux?

    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
      -DBULLET2_MULTITHREADING=ON
    ] + std_cmake_args(find_framework: "FIRST")

    system "cmake", "-S", ".", "-B", "build_double",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path}",
                    "-DUSE_DOUBLE_PRECISION=ON",
                    *common_args
    system "cmake", "--build", "build_double"
    system "cmake", "--install", "build_double"
    (lib"bulletdouble").install lib.children

    system "cmake", "-S", ".", "-B", "build_static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *common_args
    system "cmake", "--build", "build_static"
    system "cmake", "--install", "build_static"

    python_version = Language::Python.major_minor_version python3
    python_prefix = if OS.mac?
      Formula["python@#{python_version}"].opt_frameworks"Python.frameworkVersions#{python_version}"
    else
      Formula["python@#{python_version}"].opt_prefix
    end
    prefix_site_packages = prefixLanguage::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{loader_path};#{rpath(source: prefix_site_packages)}",
                    "-DBUILD_PYBULLET=ON",
                    "-DBUILD_PYBULLET_NUMPY=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPYTHON_INCLUDE_DIR=#{python_prefix}includepython#{python_version}",
                    "-DPYTHON_LIBRARY=#{python_prefix}lib",
                    *common_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Install single-precision library symlinks into `lib"bulletsingle"` for consistency
    (lib"bulletsingle").install_symlink (lib.children - [lib"bullet"])
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include "LinearMathbtPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

    cxx_lib = if OS.mac?
      "-lc++"
    else
      "-lstdc++"
    end

    # Test single-precision library
    system ENV.cc, "test.cpp", "-I#{include}bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system ".test"

    # Test double-precision library
    system ENV.cc, "test.cpp", "-I#{include}bullet", "-L#{lib}bulletdouble",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system ".test"

    system python3, "-c", <<~EOS
      import pybullet
      pybullet.connect(pybullet.DIRECT)
      pybullet.setGravity(0, 0, -10)
      pybullet.disconnect()
    EOS
  end
end