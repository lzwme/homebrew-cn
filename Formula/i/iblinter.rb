class Iblinter < Formula
  desc "Linter tool for Interface Builder"
  homepage "https://github.com/IBDecodable/IBLinter"
  url "https://ghfast.top/https://github.com/IBDecodable/IBLinter/archive/refs/tags/0.5.0.tar.gz"
  sha256 "d1aafdca18bc81205ef30a2ee59f33513061b20184f0f51436531cec4a6f7170"
  license "MIT"
  head "https://github.com/IBDecodable/IBLinter.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ab02ce27d16504d8ec99411983ecec5503a128fd940bc6d0c9c13ba7347d7632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c629f36cf48f2703306e635ad77c25ff9d6423789664bcda698403588461a598"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f71014fe66db0a03768d59175053f6d3575dcc7ea91e806cec6912d808df667"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e63e2fe2324d295afb9bba5b8a3b7475480543fcf8145b61cb5931cda5ca97d"
    sha256 cellar: :any_skip_relocation, sonoma:         "769206183628990b57eec91a82781e399a6e1581551f85308bdc1342cc8b0265"
    sha256 cellar: :any_skip_relocation, ventura:        "cc719fe755a7c5af129d7e9cf053935ff4daf35fe48ead5fbff3d4a74be49cd4"
    sha256 cellar: :any_skip_relocation, monterey:       "dc4ca4585eaa86c2fec24e712100925b460dd75ed13c8d15eab5141a88a43a30"
    sha256                               arm64_linux:    "c38241d3217c0ebb29e163e3f50cbf43308b33197e475a29b9d215286f21e504"
    sha256                               x86_64_linux:   "7284a5a01c79771e29fa8c9fe44d2cb6412ad4b09f1c3338908eeaf905c34e95"
  end

  depends_on xcode: ["10.2", :build]

  uses_from_macos "swift"

  # Fetch a copy of SourceKitten in order to fix build with newer Swift.
  # Issue ref: https://github.com/IBDecodable/IBLinter/issues/189
  resource "SourceKitten" do
    on_system :linux, macos: :sonoma_or_newer do
      # https://github.com/IBDecodable/IBLinter/blob/0.5.0/Package.resolved#L41-L47
      url "https://github.com/jpsim/SourceKitten.git",
          tag:      "0.29.0",
          revision: "77a4dbbb477a8110eb8765e3c44c70fb4929098f"

      # Backport of import from HEAD
      patch :DATA
    end
  end

  def install
    args = ["--disable-sandbox", "--configuration", "release"]
    if !OS.mac? || MacOS.version >= :sonoma
      (buildpath/"SourceKitten").install resource("SourceKitten")
      system "swift", "package", *args, "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    end

    system "swift", "build", *args
    bin.install ".build/release/iblinter"
  end

  test do
    # Test by showing the help scree
    system bin/"iblinter", "help"

    # Test by linting file
    (testpath/".iblinter.yml").write <<~YAML
      ignore_cache: true
      enabled_rules: [ambiguous]
    YAML

    (testpath/"Test.xib").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="14113" targetRuntime="iOS.CocoaTouch">
        <objects>
          <view key="view" id="iGg-Eg-h0O" ambiguous="YES">
            <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
          </view>
        </objects>
      </document>
    XML

    assert_match "#{testpath}/Test.xib:0:0: error: UIView (iGg-Eg-h0O) has ambiguous constraints",
                 shell_output("#{bin}/iblinter lint --config #{testpath}/.iblinter.yml --path #{testpath}", 2).chomp
  end
end

__END__
diff --git a/Source/SourceKittenFramework/SwiftDocs.swift b/Source/SourceKittenFramework/SwiftDocs.swift
index 1d2473c..70de287 100644
--- a/Source/SourceKittenFramework/SwiftDocs.swift
+++ b/Source/SourceKittenFramework/SwiftDocs.swift
@@ -10,6 +10,14 @@
 import SourceKit
 #endif

+#if os(Linux)
+import Glibc
+#elseif os(Windows)
+import CRT
+#else
+import Darwin
+#endif
+
 /// Represents docs for a Swift file.
 public struct SwiftDocs {
     /// Documented File.