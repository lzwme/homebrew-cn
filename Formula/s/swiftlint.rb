class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.64.0",
      revision: "4626bdf8aaebc033f65115673e6cd77d000a4d0b"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29dc3346574485e99f8626f2982c34688278c04a59414fdd19bca2ef6b8ac6cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a632d599a1b37cb418d2b630f0117bdc6c0debec0534ac15eae79d4a34553afa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b40f8f2aebd4d4c0a2bec5d39c4938beeca44315cf4c8084ad4ea6f868592c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c8d7e4369e9779be4dbdeda59251d8ad4dd09eeffa0c44809fd6c62cac93210"
    sha256 cellar: :any,                 arm64_linux:   "1c08b6e59f44cac66ecf3c640b32591b2f3be5d5be57abb3c8c7da18f0ad4db3"
    sha256 cellar: :any,                 x86_64_linux:  "5d2dedbe9ef1383be7e177966b4aa4cb397aa7ebc168dac786789a54650cdfc5"
  end

  depends_on xcode: "8.0"

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on macos: :ventura
  end

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