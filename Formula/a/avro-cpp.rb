class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.12.0/cpp/avro-cpp-1.12.0.tar.gz"
  sha256 "f2edf77126a75b0ec1ad166772be058351cea3d74448be7e2cef20050c0f98ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "291b84c78bc647e73768a8e56238854a0921e6bb4cb0719941d2224dc615d4a1"
    sha256 cellar: :any,                 arm64_sonoma:  "b4814a1221cb3c2b269295b082a7800f9e98b6e35353b5169e0cd11bde2b1204"
    sha256 cellar: :any,                 arm64_ventura: "5baa7aba33ff81ea4533abd7cea3618e388b297f9ed515e9070081aa18c5f682"
    sha256 cellar: :any,                 sonoma:        "b6871bfbea04fb244cb3703fc02b5c60f9694a7d69e8651690ac871a3a2be192"
    sha256 cellar: :any,                 ventura:       "9c38cb460359de66ad6c65bf50356a22698d9a08cf50f4ea4798a7e9acc653cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44bfb408cd8eca3fdb23efbcb046e741768f4e1de5e86c62fc00f98b68e94966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fa20bafdf7c160c06da0dc7fd48574cf2fb584e01f36a513f11a8fc0aef1056"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "fmt" # needed for headers

  # Fix compatibility for `fmt` version 11 and remove fetch_content
  patch :DATA

  def install
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
    system ENV.cxx, "test.cpp", "-std=c++14", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 19059a4..6b198db 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -82,15 +82,7 @@ endif ()
 find_package (Boost 1.38 REQUIRED
     COMPONENTS filesystem iostreams program_options regex system)
 
-include(FetchContent)
-FetchContent_Declare(
-        fmt
-        GIT_REPOSITORY  https://github.com/fmtlib/fmt.git
-        GIT_TAG         10.2.1
-        GIT_PROGRESS    TRUE
-        USES_TERMINAL_DOWNLOAD TRUE
-)
-FetchContent_MakeAvailable(fmt)
+find_package(fmt REQUIRED)
 
 find_package(Snappy)
 if (SNAPPY_FOUND)
diff --git a/include/avro/Node.hh b/include/avro/Node.hh
index f76078b..7226d05 100644
--- a/include/avro/Node.hh
+++ b/include/avro/Node.hh
@@ -219,7 +219,7 @@ inline std::ostream &operator<<(std::ostream &os, const avro::Node &n) {
 template<>
 struct fmt::formatter<avro::Name> : fmt::formatter<std::string> {
     template<typename FormatContext>
-    auto format(const avro::Name &n, FormatContext &ctx) {
+    auto format(const avro::Name &n, FormatContext &ctx) const {
         return fmt::formatter<std::string>::format(n.fullname(), ctx);
     }
 };
diff --git a/include/avro/Types.hh b/include/avro/Types.hh
index 84a3397..c0533f3 100644
--- a/include/avro/Types.hh
+++ b/include/avro/Types.hh
@@ -113,7 +113,7 @@ std::ostream &operator<<(std::ostream &os, const Null &null);
 template<>
 struct fmt::formatter<avro::Type> : fmt::formatter<std::string> {
     template<typename FormatContext>
-    auto format(avro::Type t, FormatContext &ctx) {
+    auto format(avro::Type t, FormatContext &ctx) const {
         return fmt::formatter<std::string>::format(avro::toString(t), ctx);
     }
 };