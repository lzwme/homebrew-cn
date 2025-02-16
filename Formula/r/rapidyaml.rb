class Rapidyaml < Formula
  desc "Library to parse and emit YAML, and do it fast"
  homepage "https:github.combiojppmrapidyaml"
  url "https:github.combiojppmrapidyamlreleasesdownloadv0.8.0rapidyaml-0.8.0-src.tgz"
  sha256 "232476329f0937f16488fc0425070bf0176e686ed638f8b03fd96201ea08dac5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "14f4366c7f067e0a7868ff3a7cc9a82fa17afb8015fb04165d0ad85535917fd0"
    sha256 cellar: :any,                 arm64_sonoma:  "375061f4513f3c207a9256e6fb69c6a07025b65e8b972526b2be4aad7205125f"
    sha256 cellar: :any,                 arm64_ventura: "1ef7740556d1d6b632b1c59a70e2a8c71814352fc2a7e3e1de7691fd7d055226"
    sha256 cellar: :any,                 sonoma:        "a1c64249db6aa07b91a3b31e77033de50cbd87159ec05e225e52f3af190cab0c"
    sha256 cellar: :any,                 ventura:       "444dedad7f09dbf4883d646644b5e1693d056a605083c881702c681a4a2eed28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59ada91df478aa2e07c2b50cbf4f339115c207a38815d0c0f13ee43539dbde78"
  end

  depends_on "cmake" => :build

  conflicts_with "c4core", because: "both install `c4core` files `includec4`"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <ryml.hpp>
      int main() {
        char yml_buf[] = "{foo: 1, bar: [2, 3], john: doe}";
        ryml::Tree tree = ryml::parse_in_place(yml_buf);
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lryml", "-o", "test"
    system ".test"
  end
end