class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "https:leethomason.github.iotinyxml2"
  url "https:github.comleethomasontinyxml2archiverefstags10.1.0.tar.gz"
  sha256 "9da7e1aebbf180ef6f39044b9740a4e96fa69e54a01318488512ae92ca97a685"
  license "Zlib"
  head "https:github.comleethomasontinyxml2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94a4e165cc2e528257550eaa40aeafa7ecf04f7675755b6bbabd80fe29cc7956"
    sha256 cellar: :any,                 arm64_sonoma:  "420989ffd47e892d2080b51d32f7bbb7f5ffd17fd62f604bd429bad98c17d19e"
    sha256 cellar: :any,                 arm64_ventura: "b89d53386ce4376da928ac82e2a74f9fb3bd4312afd177de7e9422c59561765f"
    sha256 cellar: :any,                 sonoma:        "1e22b22ee274991d50a5a72e3cb903fcc166c73f95fb4668f835b5b92668011d"
    sha256 cellar: :any,                 ventura:       "3b83afa4c9927e534eabc9e31803510ef86a06a87c2311ab6c6d26f31ec2fa53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0ca7bb327d5610d27894b0504b78602965a775ed8c66ed2f9ea1fb6314794de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "062be8551513e2b2eca3ac2e3ed1241de9d2b0b92282f9c605ddb45a47f56e20"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-Dtinyxml2_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    CPP
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system ".test"
  end
end