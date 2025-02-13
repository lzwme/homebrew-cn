class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https:github.comdyc3steamguard-cli"
  url "https:github.comdyc3steamguard-cliarchiverefstagsv0.16.0.tar.gz"
  sha256 "b57f1c2238ae3f5a08a106d8f42d5c72c288f458cdbeba0b37d5f83fb1cc3a9f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da90c2f8e8182e5b9dcac1ea061fb98ed69ec65fee7d9246976a2bc8c1d56499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0888e2818a15ee485674368a2e703f9f53ef9ef7d3c8d13c8f7fdacde6d9adf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "addd417cd0b2cce815ffcd08cfde925021815d1053e9b71c72fcfe2918da150b"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f8b4287b795d0eb4246ad9a8d024bd639fba17382b748db076ab320d2c470b"
    sha256 cellar: :any_skip_relocation, ventura:       "cc6bea182abebee804675f170153061ba678f73b8f35dc8aa8ca4d66df95f25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d2c72e74aa0aea06bfb8b8dcfdc55d58738fb758853e45615cddfb749d8e8b"
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