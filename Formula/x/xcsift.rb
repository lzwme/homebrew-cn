class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "48ac88921b4b8221d4e4cbacf42cdc7772bf97e5b5889f5d8afed8cffcf9ece9"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "02744b0c09effb698ebd741b2db1def9a9d30c8348c680da4fff7e0b74ab7169"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2fde5c66639c7c5827db331f87233d380e1e9fc04d787536ec739fed42647b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6dd9d95c227ee7e6840b359d5dd83be394ad71f57be767967761b295b74a2ee7"
    sha256 cellar: :any,                 arm64_linux:       "b0ad45fb18b7386acd343fd25d9a9190895069a117eae04228f703246e33d4f3"
    sha256 cellar: :any,                 x86_64_linux:      "f6a5eb164b2c41661dfc12e75818ce87e38141178f1c674d761fda850ae8cd51"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end