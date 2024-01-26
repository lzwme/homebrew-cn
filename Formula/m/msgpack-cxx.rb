class MsgpackCxx < Formula
  desc "MessagePack implementation for C++  msgpack.org[C++]"
  homepage "https:msgpack.org"
  url "https:github.commsgpackmsgpack-creleasesdownloadcpp-6.1.0msgpack-cxx-6.1.0.tar.gz"
  sha256 "23ede7e93c8efee343ad8c6514c28f3708207e5106af3b3e4969b3a9ed7039e7"
  license "BSL-1.0"
  head "https:github.commsgpackmsgpack-c.git", branch: "cpp_master"

  livecheck do
    url :stable
    regex(^cpp[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a75f1a2157ce644a3f1750478b7ba34cae5c0d354d70ffaaaccbb9c15a0e721b"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Reference: https:github.commsgpackmsgpack-cblobcpp_masterQUICKSTART-CPP.md
    (testpath"test.cpp").write <<~EOS
      #include <msgpack.hpp>
      #include <vector>
      #include <string>
      #include <iostream>

      int main(void) {
         serializes this object.
        std::vector<std::string> vec;
        vec.push_back("Hello");
        vec.push_back("MessagePack");

         serialize it into simple buffer.
        msgpack::sbuffer sbuf;
        msgpack::pack(sbuf, vec);

         deserialize it.
        msgpack::object_handle oh =
            msgpack::unpack(sbuf.data(), sbuf.size());

         print the deserialized object.
        msgpack::object obj = oh.get();
        std::cout << obj << std::endl;  => ["Hello", "MessagePack"]

         convert it into statically typed object.
        std::vector<std::string> rvec;
        obj.convert(rvec);
      }
    EOS

    system ENV.cxx, "-std=c++14", "-o", "test", "test.cpp", "-I#{include}"
    assert_equal "[\"Hello\",\"MessagePack\"]\n", `.test`
  end
end