class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https:github.comrealmSwiftLint"
  url "https:github.comrealmSwiftLint.git",
      tag:      "0.58.0",
      revision: "fcd4374431159a645d27d549ac3879f3e0ee1fa6"
  license "MIT"
  head "https:github.comrealmSwiftLint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d00e434994863073a3356e0eb6d13c71c4b7018120b98658ba3fafb74ced3ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "530ec6c7ab4c6412db0b04857ab733be63f5722b2404ba8aebf0f30ec8b33a24"
    sha256 cellar: :any,                 arm64_ventura: "6fe4758695f19509ace5b0138b3652bd1286682a972e42c1ee5dcd6a210a1754"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed908a27065f4dca7e568499528354341807b33c7303b64128b3f4d0bafd53f6"
    sha256 cellar: :any,                 ventura:       "dcebc777186154ce565abdaa7aa533d529615493242abd151f5b24114784ac92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc4bcac9acd3c18841e5db025e1230ee058acff9dd102cf5f9c459b60018bbc"
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
      shell_output("SWIFTLINT_SWIFT_VERSION=5 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}swiftlint version").chomp
  end
end