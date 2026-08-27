class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://ghfast.top/https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "eab9946fbd4aa288dbd4e72252a3066f9ba41adee749bfa081504debd41e17be"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d397bf8dc74d798f3c6a8837bf94f6e77b083cd5aee6f25ceee8a6601d15b35c"
    sha256 cellar: :any, arm64_sequoia: "6c3435e8e038c8a22d49332a06352d0a15e7440d3a47cdb7dcff637b5eab9ace"
    sha256 cellar: :any, arm64_sonoma:  "0cec008526b256de881dbb0f628152a32ebf9d698ed11e1e40d11aa4ebeb1328"
    sha256 cellar: :any, sonoma:        "adf271facd1200daa1429491f3abef820f97db6d0947bfeb1fc1b5f875e18918"
    sha256 cellar: :any, arm64_linux:   "21784350a1cacc3697a940555ae4f10e74cc92cf585b62a2469e31409bf41510"
    sha256 cellar: :any, x86_64_linux:  "71fc32b7c6a3af60443503888b722a7b8d3c26f016be7d92093da5a9b960abf6"
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