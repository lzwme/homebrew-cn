class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.2/cpp/avro-cpp-1.12.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.2/cpp/avro-cpp-1.12.2.tar.gz"
  sha256 "5e4cea5d9dc59bbc0e3e1967fd8f8a86b4cb7c1452c4b252561b8137e949f6fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "343c94a7d5a32e0b30742e9d775351e3ce51662d833bfca085fcac25b42e19b3"
    sha256 cellar: :any, arm64_sequoia: "edb049813644cdef22c0f1a94d9c27121630760ed939b836f770d41b4e18207f"
    sha256 cellar: :any, arm64_sonoma:  "8d5179f11cf31c7b4dacb5b59378a68e5c68412edf95dbc052a49f3fecccae20"
    sha256 cellar: :any, sonoma:        "73e67a5ac48130fb59827861a2865144a36358890d368ae30114f467a3980f45"
    sha256 cellar: :any, arm64_linux:   "e7a314d79d8557e10a35fe3cb743bd24d86a6c9b9fba1f7b17d2afbe045809ec"
    sha256 cellar: :any, x86_64_linux:  "d42cf3ab2efbc34b80056802d3b702886da89bfe871c0db15026d21058c416f4"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => [:build, :test] # needed for headers
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Add missing cmake file from git
  resource "avro-cpp-config.cmake.in" do
    url "https://github.com/apache/avro/raw/refs/tags/release-1.12.2/lang/c++/cmake/avro-cpp-config.cmake.in"
    sha256 "0edd19477321eea574be10972f65fc958bd7ae907de1a3974d9bffec238a01e6"

    livecheck do
      formula :parent
    end
  end

  def install
    (buildpath/"cmake").install resource("avro-cpp-config.cmake.in")

    # Boost 1.89+ no longer requires the 'system' component
    boost_replacements = /Boost\s1.70\sREQUIRED\s(CONFIG\s)?COMPONENTS\s?system/
    inreplace "CMakeLists.txt" do |s|
      s.gsub! boost_replacements, "Boost REQUIRED"
      s.gsub! "$<INSTALL_INTERFACE:$<TARGET_NAME_IF_EXISTS:Boost::system>>", ""
      s.gsub! "Boost::system ZLIB::ZLIB", "$<TARGET_NAME_IF_EXISTS:Boost::system> ZLIB::ZLIB"
    end
    inreplace "cmake/avro-cpp-config.cmake.in", boost_replacements, "Boost REQUIRED"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"cpx.json").write <<~JSON
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    JSON

    (testpath/"test.cpp").write <<~CPP
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    CPP

    system bin/"avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++17", "-o", "test"
    system "./test"
  end
end