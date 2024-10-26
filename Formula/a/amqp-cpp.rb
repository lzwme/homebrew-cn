class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https:github.comCopernicaMarketingSoftwareAMQP-CPP"
  url "https:github.comCopernicaMarketingSoftwareAMQP-CPParchiverefstagsv4.3.27.tar.gz"
  sha256 "af649ef8b14076325387e0a1d2d16dd8395ff3db75d79cc904eb6c179c1982fe"
  license "Apache-2.0"
  head "https:github.comCopernicaMarketingSoftwareAMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d42884b0048b3524ff2503b74e3606a415534df02f36b76daa738005f801c660"
    sha256 cellar: :any,                 arm64_sonoma:  "6088a49ef4492292f4643805af8808a6d3942a1f3b4e1fda5b29aefb08bc96c6"
    sha256 cellar: :any,                 arm64_ventura: "052fb79e01072ebee63a343fca762f19fb3d3586502e6049c0e8666db559663e"
    sha256 cellar: :any,                 sonoma:        "58aa9b3ed88fa9452bab84e4265c04ff686abb23cfefd9ce1b40066fa50cdacd"
    sha256 cellar: :any,                 ventura:       "a0549cf3274f68d0dd55199876406836104d0df3af6dbc4ffa56031a2b8859ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61ccf7cf9045f334afa3df40778602bdf1382d681c0ae5811ac34e6863906fcb"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DAMQP-CPP_BUILD_SHARED=ON",
                    "-DAMQP-CPP_LINUX_TCP=ON",
                    "-DCMAKE_MACOSX_RPATH=1",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-o",
                    "test", "-lamqpcpp"
    system ".test"
  end
end