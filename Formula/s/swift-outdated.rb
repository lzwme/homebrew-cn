class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://ghfast.top/https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.15.1.tar.gz"
  sha256 "a38971d81bbb167c4436f27bf2f8358183f9f62f300a1250f71bf5a633f55354"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58f67b89e3f73d27bb9f817c2c07b99df54fd0455b9b28c99aacb2ad8bf74329"
    sha256 cellar: :any,                 arm64_sequoia: "a5c0885b08db93e600ebc968af03bf5d5670d18ab78e8e9e224b8469b2858691"
    sha256 cellar: :any,                 arm64_sonoma:  "45d412df3f9ae43e3c3911e9df2459a75a57a62546efc3b84a4fe38cc118d59b"
    sha256 cellar: :any,                 sonoma:        "083bbf11dd6d244e33cf95a6ed19001842055e424b4d5eea8a8b2289c43b8c68"
    sha256 cellar: :any,                 arm64_linux:   "ba1b6cfe2802a69d1dbf57b0dffc3e156fe03820d0d0b9f2029f12b1cab70559"
    sha256 cellar: :any,                 x86_64_linux:  "999a892a6c8a2496785138261046e0d0516f3b4f22718dae99bba65c9ea652e5"
  end

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+
  uses_from_macos "curl"

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xlinker", "-L#{formula_opt_lib("curl")}"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end