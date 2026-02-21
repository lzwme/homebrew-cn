class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.2.1.tar.gz"
  sha256 "b365af378eb2ee413eec492543a065ace573c799d4c9d73a230aafb45bfefc7f"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ce5a0fabd5df9d36e391a7c7d04431497629fb0c5467a2c787c2a2f657f13ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba10141fcb7154ee09892701e56952b074bd52591787bd32066d7577a6789751"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616491b378718dd514e88b3703a7e245d20ecad96e7cff1593fab92f7345ed09"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8567e1485b7881283c8691b4c66cc02f23c9b975893ddbcd6abb76633579bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "928eea39e66b6700cdfd20301c80821e74cc53c25476cedc4e99daee81167547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b8778145d3031944356c4017c66fd4ec622803ddf0065720956efed1cb6b931"
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