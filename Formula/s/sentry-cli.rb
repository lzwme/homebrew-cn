class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/3.3.0.tar.gz"
  sha256 "41e1becb51a2b55172d64725538554a38f0c1c43fae5998523fdb30ad2bf44c5"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e186fb0a411e0a6996c6e71cba2d68e4df361309242a04e99a20be8a42fadbdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e064dbcdffc6d51b7487e55128a4b3fedbff4a2366809d2a1633544647c98c61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a1a955692b418892d9a5e14b4a9f9bd631b651f25a5225026fea9cd0147a597"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e34359aa51e4522e26768a29e891598b18ed0f7f4c75ecb6d1cbf85d3d297f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43d7c29d45a72cd3c3fa592643011564ca06a9dbce8eaf3ea5f0464ed4cd0f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3ce60b832dc798c5b8b51f12c60d5d6d62e8ab89f248410e0b9c499f1f99c02"
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