class Swiftlint < Formula
  desc "Tool to enforce Swift style and conventions"
  homepage "https://github.com/realm/SwiftLint"
  url "https://github.com/realm/SwiftLint.git",
      tag:      "0.62.1",
      revision: "57dba9819eb3e2b25daf71a06eb414fda7e43078"
  license "MIT"
  head "https://github.com/realm/SwiftLint.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "645d718d3023ab095d464a9d4dab8b9d0d8c48376cdf2988ee34a3adb7ac5524"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81c68edee38e9e0ad01f2dc2be03737ca8aa421743de4cade528e21186853132"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68de57bd124178bf18323115007cdbf0ba1e2ec582a562a2126cc7e0e7ad5342"
    sha256 cellar: :any_skip_relocation, sonoma:        "936a29b2f5854e35ced48b76a28793960f355893e25b21c1c3ba75ee97b442ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b5741f76bec584ab893f5a0736c43dc7aec73da6b0dc39db4908483c08818d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e924c70b57a9ab2cbad3eede28af82be6dce46db240fe4189a7cb6501d14ac2e"
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