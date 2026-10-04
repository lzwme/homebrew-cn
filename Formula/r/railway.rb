class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.63.1.tar.gz"
  sha256 "fd27238502741550e07bf2ccc2e739a88d77a32ee7b1bf22d6efb8bfa9853269"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2c8ff5512eb8a7363f897cfe88c5f92ae544d20529ff0ec8d3cb4b1da02e3a3c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "969f8e96f74b3ef41085acd353b67a1f3ef61de51a0faf58d9ccbb3bb8e8eaae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5831c5b56c3e2244d65a7dd6035a092a1b26afc5b91abf4890cebfabfffcf819"
    sha256 cellar: :any,                 arm64_linux:       "41f335b7cc3baa192f428438b4aefce228ef5ed564d9b033d5bfefb8c0ebd43e"
    sha256 cellar: :any,                 x86_64_linux:      "57ca3b2c412bec8bd0b78cd4e851e815ace2381c48930cbfb0667173f46485ab"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end