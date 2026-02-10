class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.2.0.tar.gz"
  sha256 "859caba03f1c022e7ba2e580a40219b77b2753f3f7dd5f472c7f8418c69a740b"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa56f21405ecfcc262a9b3f868921ba618f78cc788fd02f637b1abe9f2aa5b60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ce35c62da124417435c7c68754594ced22f4f8a069b900e3eb9a32430f3d623"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb2df85e5ebe8e36d07cb7bd8e9614081d6e971f8cbc350112e65fffbbfeb919"
    sha256 cellar: :any_skip_relocation, sonoma:        "22fb059ce209993229538133cf2a7d3aa9e61cc317862cea14a982615a84ce2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533c2b21ab425fa45d6deafaa2fca7c76437fc64f8eec1906d4ca9f48ec09c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8cd47cc28969318c0606e431d2e447548adeca800b26d3c62000e60f7af78ab"
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