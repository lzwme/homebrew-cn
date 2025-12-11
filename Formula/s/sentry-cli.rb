class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.58.3.tar.gz"
  sha256 "1491b39c3c84a8c3b994fcd333a24721bde793914e7df028c352bbc3c3d3d262"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8feb2dc458d698c1d0ae5b7cea30d0d06b9273324655f620d4a2b7ab836d3fc3"
    sha256 cellar: :any,                 arm64_sequoia: "1eeaa5b969f6da996e1901e8143068c7cbfc48854768758b00aab516fd67704d"
    sha256 cellar: :any,                 arm64_sonoma:  "f51599581d83f10df688aa1f63a15089e50a71715b6a18b2e44d42b8fa31fd6d"
    sha256 cellar: :any,                 sonoma:        "fe6664ad8f2c5e9223dadfb6cdfb56a603eee5aa79c785fd015015975c3ebb67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24f5953aaa67ddc7e10d1a51a945b694a7af24f4386d3e557cb4945d21805e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "101d50b7745a5487731c290e3ca45484bc05264a1752bb990c4dcfd3a9f7ed2a"
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