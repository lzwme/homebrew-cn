class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "20dbd1eb1c594c66e977a2d1fda0039c69fd22870d10f1a82d869f343deb975c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d840a30b2ac410589d954b640c61781e72915d48630c9d830f8268a20a011900"
    sha256 cellar: :any, arm64_tahoe:       "37d74bd5b235c2a04f28b8864e61dfe849648d0fde3bf215e95ca86c3116adae"
    sha256 cellar: :any, arm64_sequoia:     "a25de17556c641a89a5bb58ca17202a352d8804ef0b1752e222d0a0fed644db9"
    sha256 cellar: :any, arm64_linux:       "f213a5eacbd8fd54cfe2cb2d781c184ae22733070447a65e004fe803e8588843"
    sha256 cellar: :any, x86_64_linux:      "dc3a5ec1f11c605fa5edcc2a08413c02f1944608c9037e1e029cd4cb4f7a888a"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"
  depends_on "netcode"
  depends_on "reliable"
  depends_on "serialize"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DYOJIMBO_SYSTEM_DEPS=ON",
                    "-DYOJIMBO_BUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <yojimbo.h>

      int main() {
        if (!InitializeYojimbo()) {
          return 1;
        }
        ShutdownYojimbo();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lyojimbo", "-o", "test"
    system "./test"
  end
end