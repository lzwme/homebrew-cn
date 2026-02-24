class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.2.2.tar.gz"
  sha256 "e0b4aa95af432e8ca1835eab07dc7ff5fff5fbeb8fcd21320760c09ff864d0a8"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cbe4c1ff6db5b6dfea0b80bae4d6c22a2ee2ba7a8849621416de3b88fb0b767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae302d8a4b18d9883bc57dde23a57e63d224f16bbd8a01cceafd7245fa0a562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc9ae893714e1de3d362ef9c7ca5083ecf4cd16a30a4e8bade883d2a10772763"
    sha256 cellar: :any_skip_relocation, sonoma:        "56edf7a474a6057ceced3294b7511c0bf54eed9f971f51738fa77c3a5a986da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c1a89954a04d127e7cc738175828640fab37a4cdeb36018bdbaaf4908412b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eda6eec320b2b1a40aacc70926038a9f8a0e41018347ca3b1fea2fc1560daf2"
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