class SentryCli < Formula
  desc "Command-line utility to interact with Sentry"
  homepage "https://docs.sentry.io/cli/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-cli/archive/refs/tags/2.51.1.tar.gz"
  sha256 "0c7b590935d0533fdef7645249f416bf729c75714b529f48560edfbc463e3f19"
  license "BSD-3-Clause"
  head "https://github.com/getsentry/sentry-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a81a7366fcb15937cfa35673949616b7c82d33d51b56a44d442053271ab28e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55a6038987490214d299f758ad2f8fe09cce6d3a912a46a97d1e25c74bcfdc5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "873c3563ad35a2d9add7d8b026f391ff46897d1274c6a42e9eda653ed01186cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c19dd9537f55a884029e1df1cedfb47d067a78073ba1646d2a0a351b8b77004"
    sha256 cellar: :any_skip_relocation, ventura:       "62f374baed1cd7f4c6dd8fc61ed76cf221a4e56af48831403e7a0949ef8629ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e7775609559d6521397b61f9c7536ee3fe6d38aac74ab205c19ce9f25a6339c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "104935eba8d7ec8cd5a2d85bb7ff690c2fa94808adb85d88407285ccc33694db"
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