class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.0.3.tar.gz"
  sha256 "544227f0f3b404e825a1c98cf8cce330aac83ac42253d5d9ba3391cc230343be"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56a41af01e2820801268bff6eed8687cfb9e275377a9d160429a72158265811b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f28caed8c4688d7d517a56d486f4871a85a71df6cf02b9d9a6056bdc630d36ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e16ee392190319c3042c4fd35e34ca5c8ed693cfec9aa447b40b26a48c78901"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e77d4e78543e69bc5fd9143ef7a1dcbb827c1cb68c88a31790a46c2d104d2e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098725af08a9db38e0a2db88dd32da977feaeb6fa98201f44a46a640b033fcb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc79c1f310d67c25943e212c6010dfd8b969440fc25de9118bc209c24a67d632"
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