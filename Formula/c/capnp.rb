class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-1.0.1.1.tar.gz"
  sha256 "b224e61d5b46f13967b7189860a7373b96d0c105e0d6170f29acba09a2d31f57"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "714c2ec53524959f97c4e03b7861db0cbb0aec6f1185bbc4f35630736167b197"
    sha256 arm64_ventura:  "4fef4878bac3608b0c75ffa10a81f3458db7b980fef4b5661bcc74ec9bddfee9"
    sha256 arm64_monterey: "4d07365f041cc8f44853dec957ee8f51cdca14323d207594725ec9c4c37b7fdb"
    sha256 sonoma:         "abd5284dca697c41663e20c3dca129366777db57825bbf356771f6fcad0095df"
    sha256 ventura:        "afbb77dbfb505b0f3c6cc0a54dc7b094f95090c065320aab7e3969f680cfda3f"
    sha256 monterey:       "76e9c2a5ddbe996fd3304bd4a1cdbe4c74f319a3a47fa60db3d34578ac7bc4ec"
    sha256 x86_64_linux:   "837985aa7ff7b1d6513740f5812b78065750b5b38a00dc6cc15c53b59cf674bb"
  end

  depends_on "cmake" => :build
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Build shared library
    system "cmake", "-S", ".", "-B", "build_shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_CXX_FLAGS=-fPIC",
                    *std_cmake_args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"

    # Build static library
    system "cmake", "-S", ".", "-B", "build_static",
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
    system "#{bin}/capnp", "compile", "-oc++", testpath/"person.capnp"

    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-c", testpath/"test.cpp", "-I#{include}", "-o", "test.o", "-fPIC", "-std=c++1y"
    system ENV.cxx, "-shared", testpath/"test.o", "-L#{lib}", "-fPIC", "-lcapnp", "-lkj"
  end
end