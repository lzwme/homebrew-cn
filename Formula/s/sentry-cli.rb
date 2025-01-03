class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.40.0.tar.gz"
  sha256 "4c9d1b4c21cd68bfe5ade4bc356803f43d0fe00451d7298f1f7f0f71705c87dd"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd31693831feaa225bc50ff2f0ce58b10f8eaf10f008dc164bfd4f2f003e514c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "741a9b74a93ba872ad3c96e4b7f71e6b2c165822dad180e1aaf70bdf6e67a3ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5279b78f96d5bf51a62f7fe112954af0f084ce4be5076de04c76626bed315720"
    sha256 cellar: :any_skip_relocation, sonoma:        "99d765a9ef40907cc3cd3b08bfe079b840f5dbc2ba0cde77b23d48dbdd614b54"
    sha256 cellar: :any_skip_relocation, ventura:       "5f7e005265b437ad0066a4e5a875cbaf325df2f00724dded3087be53f3cbefc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409ea5182ab437be33e0ca179ff5a1b89822177cb3c18bc16993a273bfbe15c8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"sentry-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}sentry-cli --version")

    output = shell_output("#{bin}sentry-cli info 2>&1", 1)
    assert_match "Sentry Server: https:sentry.io", output
    assert_match "Auth token is required for this request.", output
  end
end