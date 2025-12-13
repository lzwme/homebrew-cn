class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.4.tar.gz"
  sha256 "e162dcf258461a100a126ccf63fe90ca8d6d516304f20a72bcef47a041a43ebc"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d9bcda5cafaf9d4fa95adec9829887d8b1d29183110f842859e3b71dacbedea"
    sha256 cellar: :any,                 arm64_sequoia: "9d87c8248bdae2badb142cf63edc8713482f06dfbd3e0816577d95fa8eca93bc"
    sha256 cellar: :any,                 arm64_sonoma:  "7e749c7f07f4a75450cc913da375bda372740f23d9f8e4a28248e38c35febb01"
    sha256 cellar: :any,                 sonoma:        "6be4bed56b37dd9f9e77bf360ac1d7755aa279c3c42435c34ad0eb7068aeb3f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d7cccd3af05a7ad66588767d83797e14dd0235b3de852481ba7fde5b46a14eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140c7b24bd9ea0476c82bb8232875f1607ba9df019f095068ec41bd847b3a9b2"
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