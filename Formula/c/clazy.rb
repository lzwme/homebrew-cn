class Clazy < Formula
  desc "Qt oriented static code analyzer"
  homepage "https://www.kdab.com/"
  license "LGPL-2.0-or-later"
  revision 2
  head "https://invent.kde.org/sdk/clazy.git", branch: "master"

  stable do
    url "https://download.kde.org/stable/clazy/1.11/src/clazy-1.11.tar.xz"
    sha256 "66165df33be8785218720c8947aa9099bae6d06c90b1501953d9f95fdfa0120a"

    # Backport support for LLVM 15
    patch do
      url "https://invent.kde.org/sdk/clazy/-/commit/20fca52da739ebefa47e35f6b338bb99a0da3cfe.diff"
      sha256 "b6f76075f9ecd9fad0d1bea84c3868de07d128df6d24c99d2de761e5718429f5"
    end

    # Backport support for LLVM 16
    patch do
      url "https://invent.kde.org/sdk/clazy/-/commit/a05ac7eb6f6198c3f478bd7b5b4bfc062a8d63cc.diff"
      sha256 "4257ed252eee84e1fa2b2b072d6cd3ff01a0a8d82a4b2f224ef783d88e341510"
    end

    # Backport support for LLVM 17
    patch :DATA # https://invent.kde.org/sdk/clazy/-/commit/05d4020614379557f733739d7f6495dc0c2ad0bd
    patch do
      url "https://invent.kde.org/sdk/clazy/-/commit/a9aabd821d8be7932c954e1cdd8d4e10f38f8785.diff"
      sha256 "15816ee3b0af43e9c4e2d81fd1811b4ed14f384dca32057ea58930961627af1c"
    end
  end

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "7930c7e75590e2e873007960e2c568efc2213a7805e1d95b06fe905e2890975e"
    sha256 cellar: :any,                 arm64_ventura:  "295d6651040ee1c9bdcd90eb7a5bbe3e5f7e1b9c5482f506b2323c9d1f51b34b"
    sha256 cellar: :any,                 arm64_monterey: "a12ee1e0f5861abdaa08009fccc7614baf1f5082927c18fb240d89230b828d70"
    sha256 cellar: :any,                 sonoma:         "4085b060be10127cb9ecfe9f3164d033c814b9831d3c2ba0d5176cddd0c81085"
    sha256 cellar: :any,                 ventura:        "a2a34ceedf8e3bdf28f4fa83d2e97d2efb8e32478b347541d950e4e87cbb12d1"
    sha256 cellar: :any,                 monterey:       "f45df63085bf00011a5453cb2f22b782a2df2ffa79aa14d75a3d8cda996178c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541e5a5facd4406bd0bf5b29a854416fb99117cabf87a553ab6a470d7d128314"
  end

  depends_on "cmake"   => [:build, :test]
  depends_on "qt"      => :test
  depends_on "coreutils"
  depends_on "llvm"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5" # C++17

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # Fix `std::regex` support detection.
    system "cmake", "-S", ".", "-B", "build", "-DCLAZY_LINK_CLANG_DYLIB=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION #{Formula["cmake"].version})

      project(test VERSION 1.0.0 LANGUAGES CXX)

      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)

      set(CMAKE_AUTOMOC ON)
      set(CMAKE_AUTORCC ON)
      set(CMAKE_AUTOUIC ON)

      find_package(Qt6 COMPONENTS Core REQUIRED)

      add_executable(test
          test.cpp
      )

      target_link_libraries(test PRIVATE Qt6::Core
      )
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <QtCore/QString>
      void test()
      {
          qgetenv("Foo").isEmpty();
      }
      int main() { return 0; }
    EOS

    llvm = deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+(\.\d+)*)?$/) }
    ENV["CLANGXX"] = llvm.opt_bin/"clang++"
    system "cmake", "-DCMAKE_CXX_COMPILER=#{bin}/clazy", "."
    assert_match "warning: qgetenv().isEmpty() allocates. Use qEnvironmentVariableIsEmpty() instead",
      shell_output("make VERBOSE=1 2>&1")
  end
end

__END__
diff --git a/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp b/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp
index ae1e607..f20c42d 100644
--- a/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp
+++ b/src/checks/manuallevel/unexpected-flag-enumerator-value.cpp
@@ -58,11 +58,13 @@ static bool isIntentionallyNotPowerOf2(EnumConstantDecl *en) {
     constexpr unsigned MinOnesToQualifyAsMask = 3;

     const auto val = en->getInitVal();
-    if (val.isMask() && val.countTrailingOnes() >= MinOnesToQualifyAsMask)
+    if (val.isMask() && val.countTrailingOnes() >= MinOnesToQualifyAsMask) {
         return true;
+    }

-    if (val.isShiftedMask() && val.countPopulation() >= MinOnesToQualifyAsMask)
+    if (val.isShiftedMask() && val.countPopulation() >= MinOnesToQualifyAsMask) {
         return true;
+    }

     if (clazy::contains_lower(en->getName(), "mask"))
         return true;
@@ -159,8 +161,9 @@ void UnexpectedFlagEnumeratorValue::VisitDecl(clang::Decl *decl)
     for (EnumConstantDecl* enumerator : enumerators) {
         const auto &initVal = enumerator->getInitVal();
         if (!initVal.isPowerOf2() && !initVal.isNullValue() && !initVal.isNegative()) {
-            if (isIntentionallyNotPowerOf2(enumerator))
+            if (isIntentionallyNotPowerOf2(enumerator)) {
                 continue;
+            }
             const auto value = enumerator->getInitVal().getLimitedValue();
             Expr *initExpr = enumerator->getInitExpr();
             emitWarning(initExpr ? initExpr->getBeginLoc() : enumerator->getBeginLoc(), "Unexpected non power-of-2 enumerator value: " + std::to_string(value));