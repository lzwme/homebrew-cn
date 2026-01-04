class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.63.0",
      revision: "e294d77dd198133c5a5cdd74e7715aa3b86dda2f"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf49cd1d9087608e6849240a83d57d9f98fcb41b34879c71e60560764b166691"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e91300dc22bfc8190deac8a3e3484b96919848b3e42c4fa8ad0257ff607dd0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "003681ffd74da65579dd437c88647aa31d3eaf3557d489ef9a5e683135065ebe"
    sha256 cellar: :any_skip_relocation, sonoma:        "206b2f03b61fa74da032d110473a11626b15b64370fa073b615d841552bfad01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caaa2878c7e679fbecee252b23c9402b8cd55ec45ec65033777520c0a534baa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea02fb9e5ccc5e854d29f9fedaa74718355de23041196d0188bf5c01950f6144"
  end

  depends_on macos: :ventura
  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    if OS.mac?
      args = ["--disable-sandbox"]
    else
      libxml2_lib = Formula["libxml2"].opt_lib
      args = [
        "--static-swift-stdlib",
        "-Xlinker", "-L#{Formula["curl"].opt_lib}",
        "-Xlinker", "-L#{libxml2_lib}"
      ]
      ENV.prepend_path "LD_LIBRARY_PATH", libxml2_lib
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