class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.42.1.tar.gz"
  sha256 "4412af776d20c8c61da653ecaa92e69137ddbe92d6921db4c9e64d52d8c88b79"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22019a5606f41e5ebbdcf30bfe1ac1f46c5cfb9e28aae00266d2e36796b64aa2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1c0c0ba9938b3e93c5ace2ffd3e7e27a7428135986071fee85c0a5f207c81fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5759ff76b5702ca9f34c19f69514f12570acf472a6409de622d6bbff28917ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "7591f90623e68da9ab21692e6f4f82eefe5b8a43ca310a805f0f2f23c225de75"
    sha256 cellar: :any_skip_relocation, ventura:       "d8a8d45645396cdda03392314b12e33dd2e0eab653f74dcdf56d7f244106dc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d75c71c6c501c5678ceebbd3f566fd93013724f555542ead73d00af3503670d9"
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