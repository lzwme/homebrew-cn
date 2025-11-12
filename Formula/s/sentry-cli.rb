class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.1.tar.gz"
  sha256 "fa7662fab5fded1a194b6555b441662fcc7d392b2cbf63d05acc6af56ea812bc"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7286a119a781ac9088d69ce9d4c95e4e01926c32ba181c2d56de39a895ac2649"
    sha256 cellar: :any,                 arm64_sequoia: "e19fc2d2baac8719567818f1b0b30b54e03b8006ac32001f2237c6527f7ea3bf"
    sha256 cellar: :any,                 arm64_sonoma:  "7188839a8390705baa265e65813ef35fb8b48799ea11b622eceb7d8c7dd9d146"
    sha256 cellar: :any,                 sonoma:        "40b1beb0e6c78c2531ae221371819bbb666883fcb91571fde294af3aa4ba7633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faaf5d69c2f06d9808b04d54e4dbab12e956415ad4e12735d793e879fc8ed716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "653d8fdb340776825579cfe1b8105293328a0bc54462b61d1cbd731cc92a7412"
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