class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.3.4.tar.gz"
  sha256 "617e9a5a09c8d2a24603e91fcd7a7b1379c0fe4cda39a015c2fa3009e0c83aee"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18aae5ffd2a257cdad62fd5f44681412845a069233b39aae6c7ee63f8ececbbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb6da0107d6c7ebc3c25bc325becbd93054d29f513d73bbb70e98766f7ee87d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfa198a85cc6ccb8ad827c599653043e885f7c4c428a29542e3cd6a0e7296d83"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8c109142f43d1fe8b335633491fca682b54aa1d943c1c2516bdd7b6ab8fede4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89aec554cacfebe1e987ff32f1f05ce7fef1a963dbc13bf19fa411c1500b9bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771f0b5623d4208b18ce6dda30c422976354e29a1ab6d152d459f17984bff4bd"
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