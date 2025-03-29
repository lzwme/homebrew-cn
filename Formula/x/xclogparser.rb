class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https:github.comMobileNativeFoundationXCLogParser"
  url "https:github.comMobileNativeFoundationXCLogParserarchiverefstagsv0.2.41.tar.gz"
  sha256 "03e0c257f202b50620b340f460504dfe3d5f6dfc725723618bf6ff98b167d9da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0506dd7d0fd34cf648007ebaa19c22ee4a7950d621d0a81ecc0de1c4ab72e36f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f12a935ef504acb540d3e894cb29f4178b78e78cab47992801cc934edb22f82a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "325dca4b969addb194bc8be42bdfdda4b61cc6549d186f1372cd7e781e03db96"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ecb9ea804d75559570439b988c2f75310052ac31362d5c39e0e58f66ed0b177"
    sha256 cellar: :any_skip_relocation, ventura:       "ce099c27e0ee07214729ee9578472919bafc72056c80e5560293715fb45701ef"
    sha256                               arm64_linux:   "5aa0b09e87329be677f7fa43e12e52e7bad79315697294d730dceeb8b06ce3c5"
    sha256                               x86_64_linux:  "3a456db1fd20985ed03089f28e6256f7c0b4441cf70ad4d4c87f12cf021cc7db"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"
  uses_from_macos "zlib"

  # patch to use linuxbrew zlib, upstream pr ref, https:github.com1024jpGzipSwiftpull71
  on_linux do
    patch :DATA
  end

  # version patch, upstream pr ref, https:github.comMobileNativeFoundationXCLogParserpull223
  patch do
    url "https:github.comMobileNativeFoundationXCLogParsercommit78b330a67b4e3c916f5ad0c68e61ba4bb163cc2a.patch?full_index=1"
    sha256 "61269c6a851c7880d88dbdd76dd41dc02505521015c415ea35b99ceea2791837"
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".buildreleasexclogparser"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}xclogparser version")

    # skip tests for linux build and sequoia macos build due to the test file issue
    return if OS.linux? || (OS.mac? && MacOS.version == :sequoia)

    resource "homebrew-test_log" do
      url "https:github.comchenrui333github-action-testreleasesdownload2024.04.14test.xcactivitylog"
      sha256 "3ac25e3160e867cc2f4bdeb06043ff951d8f54418d877a9dd7ad858c09cfa017"
    end

    resource("homebrew-test_log").stage(testpath)
    output = shell_output("#{bin}xclogparser dump --file #{testpath}test.xcactivitylog")
    assert_match "Target 'helloworldTests' in project 'helloworld'", output
  end
end

__END__
diff --git aPackage.resolved bPackage.resolved
index 900fb44..cc4b2bc 100644
--- aPackage.resolved
+++ bPackage.resolved
@@ -11,12 +11,12 @@
         }
       },
       {
-        "package": "Gzip",
+        "package": "GzipSwift",
         "repositoryURL": "https:github.com1024jpGzipSwift",
         "state": {
           "branch": null,
-          "revision": "ba0b6cb51cc6202f896e469b87d2889a46b10d1b",
-          "version": "5.1.1"
+          "revision": "29f62534648e6334678b6d7b14c6f7e618715944",
+          "version": null
         }
       },
       {
diff --git aPackage.swift bPackage.swift
index 98f46e7..068b3db 100644
--- aPackage.swift
+++ bPackage.swift
@@ -11,7 +11,7 @@ let package = Package(
         .library(name: "XCLogParser", targets: ["XCLogParser"])
     ],
     dependencies: [
-        .package(url: "https:github.com1024jpGzipSwift", from: "5.1.0"),
+        .package(url: "https:github.com1024jpGzipSwift", revision: "29f62534648e6334678b6d7b14c6f7e618715944"),
         .package(url: "https:github.comkrzyzanowskimCryptoSwift.git", .exact("1.3.3")),
         .package(url: "https:github.comkylefPathKit.git", from: "1.0.1"),
         .package(url: "https:github.comappleswift-argument-parser", from: "1.2.0"),