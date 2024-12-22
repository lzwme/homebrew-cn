class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https:docs.sentry.iocli"
  url "https:github.comgetsentrysentry-cliarchiverefstags2.39.1.tar.gz"
  sha256 "3a1d82f5b1f03a98387a76e0efa76593ff024216a191671a9b52ea9d058b2032"
  license "BSD-3-Clause"
  head "https:github.comgetsentrysentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9931f91c8f2980cecfb9aa1e4c8fa67becfe3333d4727fae6400724f637514e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af12cd66805b343c61aecfb2fe676e3d87bc195799137b8f3113b33ec2c837f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1570a9b50545af4733f9a25da1c0aaf27e01b17dd47b3a1d69c85e7b42e1294"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8dd030fc7b48ddcb6025eec455bafafbd5cc8af5151ff2a0e23628d1f92c86b"
    sha256 cellar: :any_skip_relocation, ventura:       "bbff99cf3e53df5b422510ca64db2fca50501796a2e7e9844fefa2d8f1653e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7572a6b8aa44e8dee57d1bfbd852b5a6b2aa2b0325420849509c1ac361a13d"
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