class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https:github.comrealmSwiftLint"
  url "https:github.comrealmSwiftLint.git",
      tag:      "0.55.1",
      revision: "b515723b16eba33f15c4677ee65f3fef2ce8c255"
  license "MIT"
  head "https:github.comrealmSwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "25a8cbd68645815070428bd121bb38ae6d46d06726dee56fcabc0d578ed8f879"
    sha256 cellar: :any_skip_relocation, sonoma:       "39c0c24936b847f924034aa405d55db7ac40a875d6b79c632281a0d0ade4ab42"
    sha256                               x86_64_linux: "551c6e567e00130f816eeef8b08db9013d594216e315957550ed3f8c098984e8"
  end

  depends_on xcode: ["15.3", :build]
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