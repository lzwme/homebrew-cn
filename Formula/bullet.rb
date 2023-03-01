class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  url "https://ghproxy.com/https://github.com/bulletphysics/bullet3/archive/3.25.tar.gz"
  sha256 "c45afb6399e3f68036ddb641c6bf6f552bf332d5ab6be62f7e6c54eda05ceb77"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5203e3c85c52a73d7966beb7a17964a9f28c3e2dd9dd13860f42fb3612b82ff6"
    sha256 cellar: :any,                 arm64_monterey: "1428752eba3082f8c3e609b0f10a65231d8f8383c490e232e911e2a3bc13804f"
    sha256 cellar: :any,                 arm64_big_sur:  "9451605fb3e7bbefb0c9b09233c79d5d291dd605c8cd78f664091ec72fdd9534"
    sha256 cellar: :any,                 ventura:        "a91743f519ed3f92204459cc874444207bd276310364e44c177d5e606e9e756e"
    sha256 cellar: :any,                 monterey:       "5e4cefb168bddf4ca6d8cf6d7775805b27fe5b5ede0a1fae995d5a3b8aa1c672"
    sha256 cellar: :any,                 big_sur:        "1869670cc9f22ff4dcb44ae6490d486c5611e650657ec18529fb6f9dff6b799e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17411a4bc7ea80de76276fe437acbd2b1bc58747d38891dfe48d74fe0798bc0d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https://github.com/bulletphysics/bullet3/pull/4243
    ENV.cxx11 if OS.linux?

    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
    ]

    double_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}/bullet/double
      -DUSE_DOUBLE_PRECISION=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    mkdir "builddbl" do
      system "cmake", "..", *double_args, *common_args
      system "make", "install"
    end
    dbllibs = lib.children
    (lib/"bullet/double").install dbllibs

    args = std_cmake_args + %W[
      -DBUILD_PYBULLET_NUMPY=ON
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=OFF", "-DBUILD_PYBULLET=OFF"
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_PYBULLET=ON"
      system "make", "install"
    end

    # Install single-precision library symlinks into `lib/"bullet/single"` for consistency
    lib.each_child do |f|
      next if f == lib/"bullet"

      (lib/"bullet/single").install_symlink f
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
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
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    # Test double-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}/bullet/double",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"
  end
end