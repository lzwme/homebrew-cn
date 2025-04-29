class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.43.1.tar.gz"
  sha256 "9fcae5a4426660a8153932bac7b9760567a172dfa8b15898c5a5d89dfed1a7f5"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5ad8d5014aefd697a748f2d0127013f7a75d395aef9926945aad26d37ceb5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b85e4b43f08cfca7ee55539dd6b4458ae6a8000ff6a986779ba9f15687fc74d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d4d2464239e63f89388e969f8ad5ec8ea565078a7c40b77bcd6884ef2542eb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "829b8ca8a0037b04a10c4220cc494dc9abbea0871c0b2e12347f55379a394785"
    sha256 cellar: :any_skip_relocation, ventura:       "2611f58fb5e341583107c36ae8fd84ce96dc6ff8f69d07f901f118410a81edd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5167b4a061a8956cc2c3f6b04dd78f43aa6df5d9529790ecd5d5b0ec63592678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d309d10d497e0ce558e454f58a79ec08bbd95d64f053e39350fd7a272c4c8c1e"
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