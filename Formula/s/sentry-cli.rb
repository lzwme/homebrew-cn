class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.51.0.tar.gz"
  sha256 "f42ed4e9b85ed0ec20aa033371c669edc33a1195fa3ea6a246cfd8743be5ef81"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8ec739a355fed112fbe95441188ff6d2ad10d052f131014a609818d44aa7d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce818654df003d4832e41b80f286e402d4a1f4c1294e2cf859fb59fcd9091ae3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c56f7ded6083d76596e95d3457e6cb50f680d015f8cc3c71d5a5a823773ec8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "57f243b6259a74b3182204658e280fe212f5a767cd19c99df1403d52d85ea13f"
    sha256 cellar: :any_skip_relocation, ventura:       "3dee0bb318858db666b9a0d9b51793f4a8a481afba28b2d64e96e0db091853c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c93bd64ad38c136859f8f2adbee355014fe6c0f171b8179d0812806664bb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86d131f669c13635155954b071f795a15f81327c365b9a6c6a4634bf0fdef60c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_ventura :or_older do
    depends_on "swift" => :build
  end

  on_linux do
    depends_on "openssl@3"
  end

  def install
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