class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.2.3.tar.gz"
  sha256 "9f02e60573951a4b0afb67c57bd37e05ee94d2a4a2f17b82fc5d0b0d87ac6495"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d1d2801b4326893b1432c4746231faada3ad8fb61dd56b46c291cab3ee27be5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "939f7e55300648dacb3805f0ac1d6bd2d283691dc3c9de0f864fa67d06240990"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbad37fb1e1ac415342b490981082e41cafc4f3d35e46feaae6b8d0af911e24f"
    sha256 cellar: :any_skip_relocation, sonoma:        "19099abd9372d2d3bddee501ddccb8f90b11387a9e1da1769095a857f0c6287d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc5e9008175dfd867e4b4b3987a814b27f37c37355c8abf142e335a4c04c162e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6b0ef5b7465103ec353ece1cae7b5a84908546365f2fc8f17b087c8b5250a5"
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