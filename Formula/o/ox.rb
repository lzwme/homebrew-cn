class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https:github.comcurlpipeox"
  url "https:github.comcurlpipeoxarchiverefstags0.6.8.tar.gz"
  sha256 "b9abee1d63057df8417968751c7a9fb57420a3c03cdeac26f19b598df0face32"
  license "GPL-2.0-only"
  head "https:github.comcurlpipeox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d076edaf2dd4f1249ad581f9054dd1c96efdaed6c5545b55763fe52ff0ba80e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2f6f279a7f9be3239c1572a957d03964110f25382d1055806262cfc48edcad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "236c930b951329ed393799b2bb958227b52f824f02d09c6c06f21b4e74b9f272"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d305a4a6cb35c28bbf8c7f65a1ff2f9e2ffb29cee68387c8527e1f568c29f44"
    sha256 cellar: :any_skip_relocation, ventura:       "4f90b3e79a1c3f0fed9cab016235c2c170a4c52bf0ac12d4d9031d424d29d76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4421e39fb46aadde568cc93b1c8dea68544d0c53ef797a346d1e263b9a195143"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ox --version")

    # Errno::EIO: Inputoutput error @ io_fread - devpts0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # create an empty oxrc config file to bypass config setup
    touch testpath".oxrc"

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end