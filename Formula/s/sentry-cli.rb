class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.2.tar.gz"
  sha256 "f548e09d13f8bbaab9f65d552699c939c2d2674d8f119f857bcfb61e52f6f266"
  license "BSD-3-Clause"
  revision 1
  version_scheme 1
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf435cb02574ee268a951dcf550c34c8ef4ca2a565b221a90bc1c591d435e242"
    sha256 cellar: :any, arm64_sequoia: "1f049731875db3bcbdbd34eb35f524ea0202d3ecc88599698413332f76e6d6c7"
    sha256 cellar: :any, arm64_sonoma:  "5829a74093cbedbf58178b731b9db6e0162fc83ee1fd4f481a721cc3238fdb57"
    sha256 cellar: :any, sonoma:        "91000c5e97e1fa1fcabbfde21b0cd294f23c3d3f47f7c64a3778e79507973dc1"
    sha256 cellar: :any, arm64_linux:   "0d1878f7f5d225fbc0f77400de98ba5220565f022c5aec0ded437ec0d0d92ce1"
    sha256 cellar: :any, x86_64_linux:  "506b8fed27a31901281a01013af18e735c8c41d18d7dd10baa9499e1dc864ec0"
  end

  deprecate! date: "2026-08-11", because: "changed its license to FSL-1.1-MIT in 2.58.3"
  disable! date: "2026-11-11", because: "changed its license to FSL-1.1-MIT in 2.58.3"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "swift" => :build, since: :sonoma
  uses_from_macos "bzip2"

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