class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.50.3",
      revision: "a876e860ee0e166a05428f430888de5d798c0f8d"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b7ce5d123ad1dd7ca9e7b1dda8dce1c733bfd8d5f48402f8afbc9c15aaf599c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed39b239db8bc21c6af631f6d3caccc055d2d30fe0ce829e9a44642f06d942b"
    sha256 cellar: :any_skip_relocation, ventura:        "1145a8c09a812279005df8420dcd25265baf1d900ef368aeee6ad568760aa0f4"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ce10143a0f59d79c2aa31d1274db8b19ddc1d0e69cf6f4ecf947dbf84cbf79"
    sha256                               x86_64_linux:   "e383bc2b3362ba4a37a0012cd39a587d62426fa6f22b25758f08e19a5f50ed29"
  end

  depends_on xcode: ["14.0", :build]
  depends_on xcode: "8.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".build/release/swiftlint"
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline. (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end