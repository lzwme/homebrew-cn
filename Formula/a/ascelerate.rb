class Ascelerate < Formula
  desc "Command-line tool for the App Store Connect API"
  homepage "https://ascelerate.dev"
  url "https://ghfast.top/https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.26.5.tar.gz"
  sha256 "80aa7751c3d45c5980530e96ab0da2f8af5e7e7001b135c68dd8b8037fa2bb20"
  license "MIT"
  head "https://github.com/keremerkan/ascelerate.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "c0c00c23115bfdfbb695a27992c4c2ab61521d9beafc8b3d63b020f64dd75231"
    sha256 arm64_tahoe:       "82fe0592f40eeef84993f23cffb33afda72236f6a5f97fafea001bbe2232740c"
    sha256 arm64_sequoia:     "5ba0495bc395db7e9d8d1a9bcafda0b4a04e27076a46dcf7c0d26189f01d2f1e"
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