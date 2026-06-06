class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https://github.com/biojppm/rapidyaml"
  url "https://ghfast.top/https://github.com/biojppm/rapidyaml/releases/download/v0.14.0/rapidyaml-0.14.0-src.tgz"
  sha256 "6e6e67e6b766c5a1c5fcb8b80292c7e7c15a3033c01730b41f4a91eb8a31767c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "24149099b4598da120aed04a26b8763c99030adb482d285a52577d54688c8843"
    sha256 cellar: :any, arm64_sequoia: "74c97730f84445a8b3a18dcddc672d5e2d57695752033fa306e2bd9f3f530fe5"
    sha256 cellar: :any, arm64_sonoma:  "9b46586b42adeb123c211d449930f107f4b69b4cfccdb09e56194297710dc165"
    sha256 cellar: :any, sonoma:        "74e2a21f9945a9080bfdf8f78e07c10ddfa8b29dfefa056b34347724e2b89be4"
    sha256 cellar: :any, arm64_linux:   "08fdcfe431849a9962c6b5e136436128c2819894d04be916dc0a42231457a1cc"
    sha256 cellar: :any, x86_64_linux:  "93e9e4fe044b21c196c3307f53338b64ed46884a7d54d9c013b9e4d19c873c26"
  end

  depends_on "cmake" => :build

  conflicts_with "c4core", because: "both install `c4core` files `include/c4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ryml.hpp>
      int main() {
        char yml_buf[] = "{foo: 1, bar: [2, 3], john: doe}";
        ryml::Tree tree = ryml::parse_in_place(yml_buf);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lryml", "-o", "test"
    system "./test"
  end
end