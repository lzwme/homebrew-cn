class Ascelerate < Formula
  desc "Command-line tool for the App Store Connect API"
  homepage "https://ascelerate.dev"
  url "https://ghfast.top/https://github.com/keremerkan/ascelerate/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "19763411aa5bda4d0dc1d717aeb051ca206f1b4ca7e1c2d14f467c5461584837"
  license "MIT"
  head "https://github.com/keremerkan/ascelerate.git", branch: "main"

  bottle do
    sha256 arm64_golden_gate: "a926aff0da9f6ea187042550838367b23d599b07a23d1dc1b1faa43d061843f9"
    sha256 arm64_tahoe:       "6507601957b9ffec2b5d5d16ae086052b49a5811ff4b8574ae461ff5ce0811c3"
    sha256 arm64_sequoia:     "4185ceca2ffba25278a8dbc47e0f2e2ff55eab6143c444d173c2b159439af9a3"
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