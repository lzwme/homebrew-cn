class AmqpCpp < Formula
  desc "C++ library for communicating with a RabbitMQ message broker"
  homepage "https://github.com/CopernicaMarketingSoftware/AMQP-CPP"
  url "https://ghproxy.com/https://github.com/CopernicaMarketingSoftware/AMQP-CPP/archive/v4.3.22.tar.gz"
  sha256 "a1794e49c20ed228a1b8ba9554a915236234fc778511460bf5a1af211f2fdf20"
  license "Apache-2.0"
  head "https://github.com/CopernicaMarketingSoftware/AMQP-CPP.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "879497853b31aa32312c71aa7f054fa18bf0e8923f904188ce5e1cdcb7f4ed42"
    sha256 cellar: :any,                 arm64_monterey: "ecda9554ed2b1f5905d81ef767bd8e064b4cf7b536dcfaf35b7f1616eebfc035"
    sha256 cellar: :any,                 arm64_big_sur:  "839b34c1300d85baee2d171693c79ec2b2bd23ea1ce752717781c51811b3f79f"
    sha256 cellar: :any,                 ventura:        "1ba249da6004a9e3f68801640adc179a1e7775b5550b8f668a69414edd2236be"
    sha256 cellar: :any,                 monterey:       "952f86aee2b33d507bb5005c17dd34309de2c816fcdffe26cf825f01202d1858"
    sha256 cellar: :any,                 big_sur:        "611fd491b28888e4639b7c97d1f5028554d8a924c9185ce44eac50b6a4b6df3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b7a411e86e3e2dadfa1e11cb928a1c75d161858ac1ad0e7b2dc63150202ab8"
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
    (testpath/"test.cpp").write <<~EOS
      #include <amqpcpp.h>
      int main()
      {
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-o",
                    "test", "-lamqpcpp"
    system "./test"
  end
end