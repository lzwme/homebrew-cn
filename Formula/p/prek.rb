class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "ad2a7fe633864c3b9a02bb81267d97a1741cdd231ab1df1eedf9be784a620e37"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d79f4cf2572068415986ee0711efb5b577ef0ff703a6c0b6e2e1f2b24f65faf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16ffb50b07467bad7112c44a11020c89f7f3530f09c66e263cc54d9fc2bc443f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b6424fed84acf8dfe9c8da40f101bc37f77069242b29bf6a310f3268f3a07a0d"
    sha256 cellar: :any,                 arm64_linux:       "94112434315b79aedf025092a4697024b4accc12a2c28964b2bd5f89c3154db7"
    sha256 cellar: :any,                 x86_64_linux:      "791cd8380fef074fb0103efb1acb300a6534f0d2ef2b830f799b7c9f65648cb1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end