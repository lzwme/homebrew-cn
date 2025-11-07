class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.0.tar.gz"
  sha256 "59c1c8fb6272c574a2a8f6fec1ed534a16a4b975af60d1a9e735a538d8c9c3f4"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "000334be66096d2a3561bb982fe8cbe0932561302e20fcec228288b63f97be78"
    sha256 cellar: :any,                 arm64_sequoia: "50e8dc761b76cdcc362b6c2aa9bc81cabcf91920da698d7d595e2028cd51f9c6"
    sha256 cellar: :any,                 arm64_sonoma:  "648870c82178dd6561380de695afe9e765c1faabfcc37c85205ba2758b326649"
    sha256 cellar: :any,                 sonoma:        "cb2872c0cc13a231845debf60f4079ec66dde3e7093fc1e059ba7d904199ba65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7bc496efccc6c9656b4520dfef61d94a9b6b2c64b20dea6060cccca7a439b1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e8ebf79b39f101811f05b72e48814230c0ec848441b0a091ae6d06c3576fcd"
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