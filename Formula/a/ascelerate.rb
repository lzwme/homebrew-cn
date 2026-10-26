class Ascelerate < Formula
  desc "Command-line tool for the App Store Connect API"
  homepage "https://ascelerate.dev"
  url "https://ghfast.top/https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "ebee75625a7f7ec6c8c385052da4df06ad43813084b66482f8b25b064d256cc6"
  license "MIT"
  head "https://github.com/keremerkan/ascelerate.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "353d0800673edeba8dd162e9b0ba06984dc8731b653a30c485aa2934c3412ac2"
    sha256 arm64_tahoe:       "f9f5347efe5817e90b31021737f96cffdded09baf10dff54b112e188f4ee9e37"
    sha256 arm64_sequoia:     "acc261e906e5f3eb0dbe437eedf77d487cb0fed08e072f9282b84c1bf9786392"
  end

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    # The generated App Store Connect client is one large module: optimizing it takes about 17 GB
    # of compiler memory, without optimization about 9 GB. The commands spend their time on the
    # network, so the unoptimized build runs as fast.
    system "swift", "build", *std_swift_args, "--product", "ascelerate", "-Xswiftc", "-Onone"
    bin.install ".build/release/ascelerate"
    generate_completions_from_executable(bin/"ascelerate", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ascelerate version")
    assert_match "No configuration found", shell_output("#{bin}/ascelerate apps list 2>&1", 1)

    system bin/"ascelerate", "screenshot", "create-helper", "-o", testpath/"ScreenshotHelper.swift", "-y"
    assert_match "ScreenshotHelperVersion", (testpath/"ScreenshotHelper.swift").read
  end
end