class Truetree < Formula
  desc "Command-line tool for pstree-like output on macOS"
  homepage "https:themittenmac.comthe-truetree-concept"
  url "https:github.comthemittenmacTrueTreearchiverefstagsV0.8.tar.gz"
  sha256 "38a6c3fa7328db16fdb66315ca97feb6cbbfb0a53d8af5aabd97e6d6a498a2c7"
  license "CC-BY-NC-4.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9960aec645829884e8d8544841f628be1d1338fee817e00d14496601ae0d0b76"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a29268caa4ed6ef5f5d319365ce1e4f661dccb2c7f1a28373bc2e5abfca7c87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ef4716cdbd3e811177d48fbc3203bc1491e049dfa450ed0ea8643c3f03f3c9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e83f4ed4ab289b45550c82563c0a159029e57d58501f50a9611aacbaee81c0cf"
    sha256 cellar: :any_skip_relocation, ventura:        "ec4d7164d30587724779846fe8551714a6157059d61ee34d7265643340746d65"
    sha256 cellar: :any_skip_relocation, monterey:       "db05c0a1a292c43de4d2475f8aa3cd3376b7ded7d305488f7357e98f4e17a705"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "build"
    sbin.install "buildReleaseTrueTree"
  end

  def caveats
    <<~EOS
      TrueTree requires root privileges so you will need to run `sudo #{HOMEBREW_PREFIX}sbinTrueTree`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = pipe_output("#{sbin}TrueTree")
    assert_match "This tool must be run as root", output
  end
end