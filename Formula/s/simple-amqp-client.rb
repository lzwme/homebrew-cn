class SimpleAmqpClient < Formula
  desc "C++ interface to rabbitmq-c"
  homepage "https://github.com/alanxz/SimpleAmqpClient"
  url "https://ghproxy.com/https://github.com/alanxz/SimpleAmqpClient/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "057c56b29390ec7659de1527f9ccbadb602e3e73048de79594521b3141ab586d"
  license "MIT"
  revision 6
  head "https://github.com/alanxz/SimpleAmqpClient.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6bd6bf6f3d8d9d8de51f542da48e4969953e00feb39fde3bb8f47ae85727140"
    sha256 cellar: :any,                 arm64_ventura:  "87541854d6127e353f9520e65150b53f9dc08906786b06fdad0dd14dc75feb4e"
    sha256 cellar: :any,                 arm64_monterey: "287fc84fbaece2eb235aa040f4dff6ffc6c9c95bbaf57c306e55a2d93ce85416"
    sha256 cellar: :any,                 sonoma:         "99702fa54ac07f44fc2f02a17e8684a786acbb828a00b5c44653c70769e4caea"
    sha256 cellar: :any,                 ventura:        "f7c421c9b737bb5bfd3ff194a9e9e2b1a7aea197104d74a57ba87ba7f4842990"
    sha256 cellar: :any,                 monterey:       "218104a4d4ce1ed7e3a918b23ac7d8b8d3dafc7aa5e9d5de96d04c80acdd2477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2edbc9411379b1ef91abcf2ecb1f783087ebc7cb6e2786e9a65214a350736d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rabbitmq-c"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <SimpleAmqpClient/SimpleAmqpClient.h>
      #include <string>
      int main() {
        const std::string expected = "test body";
        AmqpClient::BasicMessage::ptr_t msg = AmqpClient::BasicMessage::Create(expected);

        if(msg->Body() != expected) return 1;

        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lSimpleAmqpClient", "-o", "test"
    system "./test"
  end
end