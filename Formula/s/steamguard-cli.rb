class SteamguardCli < Formula
  desc "CLI for steamguard"
  homepage "https://github.com/dyc3/steamguard-cli"
  url "https://ghfast.top/https://github.com/dyc3/steamguard-cli/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "ed6f3ddce2cf7f377cbe1463ea051e2091bb185536c8849b346fd258137ac093"
  license "GPL-3.0-or-later"
  head "https://github.com/dyc3/steamguard-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c843e3bbd3379b3ea11594ecdd83901b13006aa6c8541fbd20f0ac31c176851a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af453aa27b4122832cb2cf2132ebcfb56691d2dfab6ae5054bd90fecec6b40a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "934a35c092e88d3be14d128cb95e913ff55c483c0e50e9e55fbf62a88be54174"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a57713b5f7eb04cea229a94c6b39a541923fab9ee0abb94b1b4815bf5bd9f47"
    sha256 cellar: :any,                 arm64_linux:   "9da602e8519a0f48c5715b9f89882ef11286e8641cea637da705e1585d1d8dfa"
    sha256 cellar: :any,                 x86_64_linux:  "d15bd2e2a3a9b3c87486ea478e9e78aafe7c76606dbaf9a4af304bbbd9e477d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"steamguard", "completion", shell_parameter_format: :arg)
  end

  test do
    require "pty"
    PTY.spawn(bin/"steamguard") do |stdout, stdin, _pid|
      stdin.puts "n\n"
      assert_match "Would you like to create a manifest in", stdout.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  end
end