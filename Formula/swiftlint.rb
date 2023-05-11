class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.52.0",
      revision: "97259e24d065506f811789b56bb95dc14f2b72f1"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea0eaa9360506423a70d38f367bc92258cd2a3e8063fa1233e67bd6f430629bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0381c7b3aec2dc26ec3a46b7c75cb1344ecfcbab8fbe20a7a60e24307c7738c0"
    sha256 cellar: :any_skip_relocation, ventura:        "75a61ccedce2cc0a33b76f24a3a54c01e68568c31101c495de15e79a7ae0fdfd"
    sha256 cellar: :any_skip_relocation, monterey:       "281d986471c5b174f4bead8f7938cda65f945dcbe7c6049c326ddd96c34f2f4f"
    sha256                               x86_64_linux:   "cfd9822fcd1993bafdd07e4e71f5afd773da3bf26aa4bf349a41d26a90d9c65a"
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
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end