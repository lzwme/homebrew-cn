class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.42.4.tar.gz"
  sha256 "1713f10ec317f7b1d40c18e72bb901e576eb4899b05a74f5a207f25b8b9d87d0"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "305a83c5a57533c72da413fb6f8611ae6d0ce274068ffb946a7f8fc201a5b732"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "189679fa82c8702308c6612fc3864ff6597789669d8971551a5c9b3c3f061cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af995079009413cb4e1263515883bbe63d6168be3405cd324e07883b130d40bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc6072aaf65af9137302112b121b61cceb9ea3727d1d5a0822a48a9cbd8ed1df"
    sha256 cellar: :any_skip_relocation, ventura:       "8a4157263351ceb0446b1856909a72a24aff23e83ad7a3994ee75f632b33f3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59121de3c282cd0e4597a4e1bd0aadd019f1b1c46321625cd6c102dc7e827f3e"
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