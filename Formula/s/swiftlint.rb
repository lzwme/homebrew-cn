class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https:github.comrealmSwiftLint"
  url "https:github.comrealmSwiftLint.git",
      tag:      "0.57.0",
      revision: "168fb98ed1f3e343d703ecceaf518b6cf565207b"
  license "MIT"
  revision 1
  head "https:github.comrealmSwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29bfd9c9a44b1bdaf6656571d40192c570d6afefbce48a90a923cae6d52875b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1862b912a0e6d3574761ee710cca00a53e831d92e080f448b8fe286cccc4ab8"
    sha256 cellar: :any,                 arm64_ventura: "08c334c98bbfaa64ee5cda057cb634981e9409249f493b5d40abf02b2cc24f3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f46a96f444a1ce89c53a183e5e95d26201276474eff7cb82dd30c3103ae2b11d"
    sha256 cellar: :any,                 ventura:       "35fdde7dc00368c3d65f03dc4290190351af844b4296f2e9cc9bfdbcf6bcce2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa5ef711b796a028a2f1d0b6d3b2d742f33b25738a13ebd884962f5b883abf6"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "swiftlint"
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