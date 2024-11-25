class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https:github.comrealmSwiftLint"
  url "https:github.comrealmSwiftLint.git",
      tag:      "0.57.1",
      revision: "25f2776977e663305bee71309ea1e34d435065f1"
  license "MIT"
  head "https:github.comrealmSwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24fe83d074121c61eddc8e0ce97459f6cec7393a79162323f2c03125cd18044f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95fada89bf1eac5448fb2dcbdf6f06930bbd7e64e9995fafa8127fd45a2ef39"
    sha256 cellar: :any,                 arm64_ventura: "74e0c40b96bb5f22796b36cba94defa8574b94498844996c9f59126c16d43fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "952ac6d4f9a1b8db04522c00db594b6db8d7c705ca34f36c96b12aa3eba01e12"
    sha256 cellar: :any,                 ventura:       "7be636e0965b85f1fac348e4842e1039e4987fb2f1c09d0d25039f9310013e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a969d3560456460863fcd619204207adbee2a24c1d4b9c5e3ed8055007b9aa55"
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