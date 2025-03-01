class Dlib < Formula
  desc "C++ library for machine learning"
  homepage "http:dlib.net"
  url "https:github.comdaviskingdlibarchiverefstagsv19.24.7.tar.gz"
  sha256 "fb3213872b4755cbc75d88cdd3cf77555d353ac89bc105f7acb33bf665f4b2a7"
  license "BSL-1.0"
  head "https:github.comdaviskingdlib.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52dd001745814c924a87cf42e3a82a00d4fa35061da36038e623d77ebe8cb6c0"
    sha256 cellar: :any,                 arm64_sonoma:  "7d6b9431c4c80283cab042f29859d806a899e98d0b521f1b18c279701a6bc68c"
    sha256 cellar: :any,                 arm64_ventura: "6c13f0a4c98d13b642c297dc8ced48ac0826233edbe1b88c67449a9ac1d60765"
    sha256 cellar: :any,                 sonoma:        "29cceffca57a7529f134d56dcd31747b0a8af60a4575839677d855fd8a331008"
    sha256 cellar: :any,                 ventura:       "e714e65742db67b08dfa50ad9b73f683fc4864bce7f8e1ee916e5d012ee76b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d56996e946269b3ba5cde4519f5bbe39bb98b86673144968ec3f6d7fefb91b"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openblas"

  def install
    args = %W[
      -DDLIB_USE_BLAS=ON
      -DDLIB_USE_LAPACK=ON
      -Dcblas_lib=#{Formula["openblas"].opt_libshared_library("libopenblas")}
      -Dlapack_lib=#{Formula["openblas"].opt_libshared_library("libopenblas")}
      -DDLIB_NO_GUI_SUPPORT=ON
      -DDLIB_LINK_WITH_SQLITE3=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    if Hardware::CPU.intel?
      args << "-DUSE_SSE2_INSTRUCTIONS=ON"
      args << "-DUSE_SSE4_INSTRUCTIONS=ON" if OS.mac? && MacOS.version.requires_sse4?
    end

    system "cmake", "-S", "dlib", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <dliblogger.h>
      dlib::logger dlog("example");
      int main() {
        dlog.set_level(dlib::LALL);
        dlog << dlib::LINFO << "The answer is " << 42;
      }
    CPP
    system ENV.cxx, "-pthread", "-std=c++14", "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-ldlib"
    assert_match(INFO.*example: The answer is 42, shell_output(".test"))
  end
end