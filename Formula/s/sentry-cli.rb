class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.4.3.tar.gz"
  sha256 "62693c24c15f6a7ffefe5837bfbe7fc2fa98ed621a29cddb41d828f9f27911a5"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19a287c2a540c26b3ebc4ee77b6af1751a26617c60537c1e07847092fcc27968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b54bd38f595416e0e3c0496c86452553c63299ffe15e38019cb535e1fcc4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd91d2a008180494d8f535986208cd1f31d0b0c097cdc0669ab33258be49718f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8468a1386cf4bd963a003fc33adc31928c59d92ddf20509f17f853e033027f4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e642edba5464dcc28d68b60517dbb5ec4f74192aeb08a13c7360e419b096a976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dab798bedcbb06a230eab7dbf7e98bc9ecad461ac83bc6f2e3d28dd9606f9763"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
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