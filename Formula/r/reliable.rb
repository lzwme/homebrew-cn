class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://ghfast.top/https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "fbd2d964b0808720e6f46bd6629af8b8ca62378dd60d06b542666903972366e2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "31551625e3d6601d1b616bc61f88667b21b946b5a2e2da62aeffded7bdd8d0fd"
    sha256 cellar: :any, arm64_sequoia: "4d3730a3f4e017c6c2cedfca065213484bfe8346122f6810475f0f65cb42383c"
    sha256 cellar: :any, arm64_sonoma:  "be7ba0578a059994a89b1773ee16f98ae532a54be185fe098686e9b431146b94"
    sha256 cellar: :any, arm64_linux:   "71bef37a85df0e5e940ca677845e84cf53b068490372741dc06ab2a36cb0a5d5"
    sha256 cellar: :any, x86_64_linux:  "e6af0ed492c48c86ecc23d471a81aa41d815e2bd31e6c352af7f4dfced7f3cb3"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <reliable.h>
      #include <stdio.h>

      int main() {
        if (reliable_init() != RELIABLE_OK) {
          return 1;
        }
        printf("%s", RELIABLE_VERSION_FULL);
        reliable_term();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lreliable", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end