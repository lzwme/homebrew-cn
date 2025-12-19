class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://ghfast.top/https://github.com/capnproto/capnproto/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "01ab2ba7f52fcc3c51a10e22935aae56f3bc5e99b726b7e507fe6700cb12147d"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "v2"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f56d8d6a7908f45ad6b9304ebeec5c20f8ffb049911d129aed81b60b377fa4dd"
    sha256 arm64_sequoia: "f41fee1317b745f8bcd6855dd1ec95deb5181b876c34731904cd0d91c4ae31df"
    sha256 arm64_sonoma:  "9e4290ac485126048dba7b742b13b54329ea7bc17d7cb2bc11f624daf92d1af1"
    sha256 sonoma:        "0871e73f16c2707186a4ec8ebddc9976f8a576ec44db531db8743306929f2c87"
    sha256 arm64_linux:   "4416f977ef5a1497696be71a27547eee795a5a43677de79c06a083e4c56b5b04"
    sha256 x86_64_linux:  "28d742cf52dcff528d8a55ea3c0ef6a1e6a18f1537536b01f78c9c1cbefce63a"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DCMAKE_CXX_STANDARD=20", # compile coroutine support, remove with 2.0 update
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_FLAGS=-fPIC",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library
    system "cmake", "-S", ".", "-B", "build_static",
                    "-DCMAKE_CXX_STANDARD=20", # compile coroutine support, remove with 2.0 update
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DCMAKE_CXX_FLAGS=-fPIC",
                    *std_cmake_args
    system "cmake", "--build", "build_static"
    lib.install buildpath.glob("build_static/src/capnp/*.a")
    lib.install buildpath.glob("build_static/src/kj/*.a")
  end

  test do
    ENV["PWD"] = testpath.to_s

    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write shell_output("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")

    (testpath/"person.capnp").write <<~EOS
      @0x8e0594c8abeb307c;
      struct Person {
        id @0 :UInt32;
        name @1 :Text;
        email @2 :Text;
      }
    EOS
    system bin/"capnp", "compile", "-oc++", testpath/"person.capnp"

    (testpath/"test.cpp").write <<~CPP
      #include "person.capnp.h"
      #include <capnp/message.h>
      #include <capnp/serialize-packed.h>
      #include <iostream>
      void printPerson(int fd) {
        ::capnp::PackedFdMessageReader message(fd);
        Person::Reader person = message.getRoot<Person>();

        std::cout << person.getName().cStr() << ": "
                  << person.getEmail().cStr() << std::endl;
      }
    CPP
    system ENV.cxx, "-c", testpath/"test.cpp", "-I#{include}", "-o", "test.o", "-fPIC", "-std=c++1y"
    system ENV.cxx, "-shared", testpath/"test.o", "-L#{lib}", "-fPIC", "-lcapnp", "-lkj"
  end
end