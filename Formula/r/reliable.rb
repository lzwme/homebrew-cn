class Reliable < Formula
  desc "Simple packet acknowledgement system for UDP-based protocols"
  homepage "https://github.com/mas-bandwidth/reliable"
  url "https://ghfast.top/https://github.com/mas-bandwidth/reliable/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "fc9f8011047cbb6ad5e2e0c64ccb5d62d112b78f434ed1add173872b32d6771f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82fa0d47486a07fcf73466c8bf3fca04529ac993cf346db0ea4652a830a9368c"
    sha256 cellar: :any, arm64_tahoe:       "09dc8d1ae363f8c0e01569a8cab41e4f69cce1200926cd37c86a1ce6831d62f2"
    sha256 cellar: :any, arm64_sequoia:     "24a61726eff11157bf10f7d4cf9866d76d627517afc93d3de219ebf733476f09"
    sha256 cellar: :any, arm64_linux:       "d645840187e99895628f62a6e23db3eb94d4f0a75749343b48d4230a46577bcf"
    sha256 cellar: :any, x86_64_linux:      "b981da8513393f34433ddfbe56116254aa400d6826a928b5915d5fa3aeb040ca"
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