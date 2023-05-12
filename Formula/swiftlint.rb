class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.52.1",
      revision: "5616d858bc23a724003e1bc09e1feb7c5fe914c3"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b545f6503d840a7c64e94381153295dec2d20af4f0cf40571ae303562657d63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076d49735c3f4d5bc75beaa256ced601e93d8721b39873009c9dcdfae07fd752"
    sha256 cellar: :any_skip_relocation, ventura:        "54b5c4b2e9ca0aaad90ee64f75d7ee77ff2d8cb15cbc8b82ee8d21ff3887e27d"
    sha256 cellar: :any_skip_relocation, monterey:       "f1b5642787700e21e64277a1d18d6fd3834dae2782cb2226bdfa75f7845d0800"
    sha256                               x86_64_linux:   "37f73376944a1ea8f6fdfd9f225bc2e194f0bc4dc7fc4f47dddd4b83508d6d58"
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