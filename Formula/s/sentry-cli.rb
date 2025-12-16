class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.0.0.tar.gz"
  sha256 "2159b2a6a4fe30515af23b7b404b74f5e7b36a2ee451db6e0b115904a6516084"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58c8692e9da568ef2ced853b842264888fcfe2e125f9569c75a47248a10fba1e"
    sha256 cellar: :any,                 arm64_sequoia: "160a03f717a173ffa3eecb3f381afd13e3ab2b3cb13454309299d22e98ae9cc8"
    sha256 cellar: :any,                 arm64_sonoma:  "518ad64984a7224c9ddb4071c0c2c8729a13c89c07936888bfc93275b9c33809"
    sha256 cellar: :any,                 sonoma:        "9053a720413d725fb108d8f1f089008ab1229078717a28fab25919660f7acaf3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aceda97791d9b5fc488eafbdf1c3c28beec25b6f4fe29a60b95d62cd5e368c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86540a8587c9b814b88ce81069054599f133f35b73b0310c927cc93892f218d9"
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