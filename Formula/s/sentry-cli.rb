class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.50.2.tar.gz"
  sha256 "1451f79c89834b2ff7c9482f210542a6e8bd1354a4c55bba1812751ec11abba3"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7857244e2b6545f0a0de3d1cd223b68869427c350c1b6956803082e715b75086"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cffbb5324666346acca7da42d9716347da002e6f863ed81023a1eb65da1df39f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58cf081b76a757774663e9f9959e7f1cd2dd6cfc7bd0fdc80009861f6c788074"
    sha256 cellar: :any_skip_relocation, sonoma:        "842e09cd27f8319c3fc3f9a8b385a41867c5f7ccb348d3f6a3624fa9ee4cdae2"
    sha256 cellar: :any_skip_relocation, ventura:       "1a6d5582e4780664f0e5bbd009687201527d9f830a9f47ca82008f0e808a661a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4a33f8a8272c2817daf4bfd997775e9df7da934d7a68e6d690305a02b919fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "532815a9f0f56e136b562b33ab710dbca8206d744a72f2ba0e6fc5ddb7dc4a31"
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