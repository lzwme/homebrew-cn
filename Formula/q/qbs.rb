class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms"
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/3.0.3/qbs-src-3.0.3.tar.gz"
  sha256 "5ea02139263ec4dbf947d18f4a73ccc41f691ec43c5914a6a6b089d9713ec0dc"
  license all_of: [
    { any_of: ["LGPL-3.0-only", "GPL-2.0-only"] },
    { any_of: ["LGPL-3.0-only", "LGPL-2.1-only" => { with: "Qt-LGPL-exception-1.1" }] },
    { "GPL-3.0-only" => { with: "Qt-GPL-exception-1.0" } },
  ]
  head "https://code.qt.io/qbs/qbs.git", branch: "master"

  livecheck do
    url "https://download.qt.io/official_releases/qbs/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "744c54ac7722c99cd35fff1243b7149bc342e722b9f730656a3f948a313018b6"
    sha256 cellar: :any,                 arm64_sequoia: "897b6fbf6667d4ba08ccc8baed8435d2dd2710d26a7400311e407a1fed49f9ce"
    sha256 cellar: :any,                 arm64_sonoma:  "f362ce03374da267567565ddcbc3a04a698651c1b5a0d55d18148e28c8124c60"
    sha256 cellar: :any,                 sonoma:        "0c3d67b19b77163bebd1245fbf4111ab96ceef403a5938550790dca2e07f560b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fa26c6fe79c5614f055df559f2c3aaa3f320698e52552257aa6654cfe06761d"
  end

  depends_on "cmake" => :build
  depends_on "qt5compat"
  depends_on "qtbase"

  # Backport support for Xcode 26 from upstream commit:
  # https://github.com/qbs/qbs/commit/2f3e8254573045fab7ebd487aa773527a3da642c
  patch :DATA

  def install
    args = %w[
      -DQBS_ENABLE_RPATH=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      int main() {
        return 0;
      }
    C

    (testpath/"test.qbs").write <<~QBS
      import qbs

      CppApplication {
        name: "test"
        files: ["test.c"]
        consoleApplication: true
      }
    QBS

    system bin/"qbs", "run", "-f", "test.qbs"
  end
end

__END__
diff --git a/share/qbs/modules/bundle/BundleModule.qbs b/share/qbs/modules/bundle/BundleModule.qbs
index 647663043eb7128249d956fdbc633943739c7be2..518b8a2aac3889816a9c43a1b93aa88eafcff28a 100644
--- a/share/qbs/modules/bundle/BundleModule.qbs
+++ b/share/qbs/modules/bundle/BundleModule.qbs
@@ -93,6 +93,8 @@ Module {
             if (xcodeDeveloperPath && useXcodeBuildSpecs) {
                 specsPaths = Bundle.macOSSpecsPaths(xcodeVersion, xcodeDeveloperPath);
                 specsSeparator = " ";
+                if (Utilities.versionCompare(xcodeVersion, "26.0") >= 0)
+                    specsSeparator = "";
             }
 
             var reader = new Bundle.XcodeBuildSpecsReader(specsPaths,
diff --git a/share/qbs/modules/xcode/xcode.js b/share/qbs/modules/xcode/xcode.js
index 726974579039fe6bd746b1eee7c49c112086e4bc..4706272851b13f8b9eb79ee503828286981296fd 100644
--- a/share/qbs/modules/xcode/xcode.js
+++ b/share/qbs/modules/xcode/xcode.js
@@ -202,6 +202,32 @@ function boolFromSdkOrPlatform(varName, sdkProps, platformProps, defaultValue) {
     return defaultValue;
 }
 
+function specsBaseName(version, targetOS) {
+    const targetPlatform = targetOS[0];
+    const oldSpecNames = {
+        "macos": "MacOSX Architectures",
+        "ios": "iOS Device",
+        "ios-simulator": "iOS Simulator",
+        "tvos": "tvOS Device",
+        "tvos-simulator": "tvOS Simulator",
+        "watchos": "watchOS Device",
+        "watchos-simulator": "watchOS Simulator"
+    };
+    const newSpecNames = {
+        "macos": "macOSArchitectures",
+        "ios": "iOSDevice",
+        "ios-simulator": "iOSSimulator",
+        "tvos": "tvOSDevice",
+        "tvos-simulator": "tvOSSimulator",
+        "watchos": "watchOSDevice",
+        "watchos-simulator": "watchOSSimulator"
+    };
+    if (Utilities.versionCompare(version, "26") < 0) {
+        return oldSpecNames[targetPlatform];
+    }
+    return newSpecNames[targetPlatform];
+}
+
 function archsSpecsPath(version, targetOS, platformType, platformPath, devicePlatformPath,
                         developerPath) {
     if (Utilities.versionCompare(version, "13.3") >= 0) {
@@ -218,13 +244,7 @@ function archsSpecsPath(version, targetOS, platformType, platformPath, devicePla
         var baseDir = FileInfo.joinPaths(pluginsDir,
                                          "XCBSpecifications.ideplugin", "Contents", "Resources");
 
-        var baseName = targetOS.includes("macos") ? "MacOSX Architectures"
-                : targetOS.includes("ios-simulator") ? "iOS Simulator"
-                : targetOS.includes("ios") ? "iOS Device"
-                : targetOS.includes("tvos-simulator") ? "tvOS Simulator"
-                : targetOS.includes("tvos") ? "tvOS Device"
-                : targetOS.includes("watchos-simulator") ? "watchOS Simulator" : "watchOS Device";
-        return FileInfo.joinPaths(baseDir, baseName + ".xcspec");
+        return FileInfo.joinPaths(baseDir, specsBaseName(version, targetOS) + ".xcspec");
     }
     var _specsPluginBaseName;
     if (Utilities.versionCompare(version, "12") >= 0) {