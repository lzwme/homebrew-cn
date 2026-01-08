class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.0.2.tar.gz"
  sha256 "9d5bc2796b6187322f630facee47ed7292a0788978a94e0f8e7d80655a75c20f"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e3520d3552bab2c9e0531931a04abba1f96b7293b1c95b1b3471bfb0bf7797d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07e82f7945f9e8f6b00b9bd3d8a8ec2778fc15b8dfc96a725e0cfe69e93e22e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49c861b830062874eb470b0b93ae5ac522d156eb61888a4c8e7d684e65287a3f"
    sha256 cellar: :any,                 sonoma:        "c9a7dcb79230081ae94050ce4375bbc9bfada61c0cee41bed49bd012e857fbae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2dbac2fda9bf63fa5482586494dd22c6afb18fab5afc2405dbb7e7a65a62c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bd2a08ba309b68769e460cf369e0c8be1fe43cd613bfbbb21fe5adc5996b910"
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