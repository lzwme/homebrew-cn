class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.56.1.tar.gz"
  sha256 "402913b8ddb19aa999bf213f97bd047425ac7140c9989128540ac1e0e5ab7340"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f9b5f075bad1c61ed7d1ee13ed08e4d66b8b234a7f0a2483db7451429bc59cf"
    sha256 cellar: :any,                 arm64_sequoia: "63dc9c0c98199aa10c61366110ac2a4dfa03f2b12f04d0edba8cb6087bdccfc2"
    sha256 cellar: :any,                 arm64_sonoma:  "258693b613fc0c969849766a5f3140b325e1781cca92e9e4f9d1c39d233a9a4d"
    sha256 cellar: :any,                 sonoma:        "3e31c8a20852e4220af1ed1e9cc81210efa14411b6fe28cf0ec930f64e11e26b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20eff4cc3304206e43a5e6e01142b9ef8fa52c7c3704f6af6f865c2104fc41a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "253616ccff83212b6e7b691933db74d7b45420f1902814d9590d7198ac5c12ae"
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