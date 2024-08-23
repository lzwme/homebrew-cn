class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https:github.comrealmSwiftLint"
  url "https:github.comrealmSwiftLint.git",
      tag:      "0.56.2",
      revision: "a24488f26e60247d8fff7bbb03d51910af3dc91c"
  license "MIT"
  head "https:github.comrealmSwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469a5731c0e6b3af1bdb5dce29a5cc216a985af3bc2a8d70faeeac9b7296c2c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6eef64cdd6d5c9ef7a413fa3584dbd46cbfa6c73abac65b40fc6d8b6bf1bf61d"
    sha256 cellar: :any_skip_relocation, sonoma:        "73204b3fc14fa1e688324b895ef646811de5f6abb0bb473f017bbe16f6645d17"
    sha256 cellar: :any_skip_relocation, ventura:       "52eb97a079b395c73863a3ec6c711562d72e80702f9db03b33755729a28acc7f"
    sha256                               x86_64_linux:  "cf272ee700fd6d707af8ae229432525347de890924ef91a20f9a42ce9a76ffbb"
  end

  depends_on "swift" => :build
  depends_on macos: :ventura

  depends_on xcode: "8.0"
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "swiftlint"
    bin.install ".buildreleaseswiftlint"
    generate_completions_from_executable(bin"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=3 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}swiftlint version").chomp
  end
end