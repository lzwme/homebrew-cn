class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.52.4",
      revision: "9eaecbedce469a51bd8487effbd4ab46ec8384ae"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3059eec6d6d9f48b27ebcb4c7e72059782ecda880a71751f8f1efef19ea4a0c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0661946538e0f54c7fc4a099bec95196f9bf8b0edb2fed6f9f791383f8e014d9"
    sha256 cellar: :any_skip_relocation, ventura:        "0808765e7430b049dc0e4f1a494408c27a259aeec39ca01d375bb7fa8b170c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "9c247206cf1549cad93ce2a99d7d82efbeffbad15f84acafc02bebb3d95fee0d"
    sha256                               x86_64_linux:   "456c2065f16e91ace42e75f2849b5ec40c2cc70252155a8b6a11b5daa18939db"
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