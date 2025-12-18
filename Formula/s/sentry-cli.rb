class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.0.1.tar.gz"
  sha256 "2c9e27b19df72d6ac18ef506662f49a013eefb969023ac9cb62b8f030702ea8f"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f21cf1c34bf65243fde6157233d51817d5c384a385a399245f7d69aa70a4c4f1"
    sha256 cellar: :any,                 arm64_sequoia: "c40d3b4c7a0c66c7ce9107d73dbbab8691a402f30f4b5943de86f354b51eafd9"
    sha256 cellar: :any,                 arm64_sonoma:  "d434fe328e7eb78ce2c62a2dc72c02ada679a72d22ac4ffe144bf149e536803c"
    sha256 cellar: :any,                 sonoma:        "3c3df101f91e7d69051fa411f876e8bf3da418c795fafe9370e90a4320de0dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efcd828f015e4bae676cc732dd4fcff7bb436488309a2d94e541ff0e1ada5d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c3a1f962b015e9b0a29b70b45e20e6ac8a82d6b4bf6c8716c54d2d27a578b0c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  def install
    ENV["SWIFT_DISABLE_SANDBOX"] = "1"
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version")

    output = shell_output("#{bin}/sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https://sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end