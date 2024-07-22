class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https:github.comdyc3steamguard-cli"
  url "https:github.comdyc3steamguard-cliarchiverefstagsv0.14.1.tar.gz"
  sha256 "6c5a2aa51b996f59585cef62ed27f05dbf1dd8430f1d7b842cd955196395cf98"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f155d410492a9f16d3d5baef6d6b644945421340932f2e58054491239e170d33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6fac92d73ecadb1c2823cf76815f628f2bcf88f5f96e23a79b7769d3a3bc43e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "907709cda293831225b3ca45682ce9c5078451860d29b11b5cfecb0893887d75"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0134089ea172725a366b3eaebfeb7b95cf029ec47875587889aa189cc0b4ee7"
    sha256 cellar: :any_skip_relocation, ventura:        "119c12a7d059b5aec0ff84202fb183160d979c5821d661684a60f0f2a1f7cb56"
    sha256 cellar: :any_skip_relocation, monterey:       "5b7dec26f7527ade447921eb645b7d804456fe0f3c8d5ae2efc4affa5e327ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e0768ff7c302a499a9d816b79e3ebda1c9908af8f408072db017c45c182630b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"steamguard", "completion", shell_parameter_format: :arg)
  end

  test do
    require "pty"
    PTY.spawn(bin"steamguard") do |stdout, stdin, _pid|
      stdin.puts "n\n"
      assert_match "Would you like to create a manifest in", stdout.read
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end
  end
end