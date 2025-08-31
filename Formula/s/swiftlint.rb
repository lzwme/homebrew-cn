class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.60.0",
      revision: "a351a0dea2ccf0fc1925620118821dd6d3ef55c4"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff2334d36d563ef25bbd8e86e7abfb6c5f12339cf60db80844ab4e227ad87fa3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3611bd3afcd7b68d6f8fc3b2038c88f403bcf52d361fba11bcb955fde605d77"
    sha256 cellar: :any,                 arm64_ventura: "29f16e9df523bbf220c25cc1cac7e3209d2be5138c3ae3761b34e2cd309e0908"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e47ac01ab9cf6f765890da887a2249e4fff3893ae866bd292a25731222896f2"
    sha256 cellar: :any,                 ventura:       "cc7bfb0168663627fb0127e1f8a019a911bc42e85fc79d468fb8a2a63df48402"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8a4bf56aed46e7b57dcc3dc6e37c94de2d768f0cba6d3a9fc195fcddea2af07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e36f564db21f3be88ab8edbfe995f7ee20c80cb78ac15536df3155c41101be2c"
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
    bin.install ".build/release/swiftlint"
    generate_completions_from_executable(bin/"swiftlint", "--generate-completion-script")
  end

  test do
    (testpath/"Test.swift").write "import Foundation"
    assert_match "Test.swift:1:1: warning: Trailing Newline Violation: " \
                 "Files should have a single trailing newline (trailing_newline)",
      shell_output("SWIFTLINT_SWIFT_VERSION=5 SWIFTLINT_DISABLE_SOURCEKIT=1 #{bin}/swiftlint lint --no-cache").chomp
    assert_match version.to_s,
      shell_output("#{bin}/swiftlint version").chomp
  end
end