class MsgpackCxx < Formula
  desc "MessagePack implementation for C++  msgpack.org[C++]"
  homepage "https:msgpack.org"
  url "https:github.commsgpackmsgpack-creleasesdownloadcpp-6.1.1msgpack-cxx-6.1.1.tar.gz"
  sha256 "5fd555742e37bbd58d166199e669f01f743c7b3c6177191dd7b31fb0c37fa191"
  license "BSL-1.0"
  head "https:github.commsgpackmsgpack-c.git", branch: "cpp_master"

  livecheck do
    url :stable
    regex(^cpp[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d57131d53cd03e4a0c434c5e80c2f4026a41dc4697b53bdda1b765fa7b8495b7"
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