class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "c14bfbb5121c24421aea5fbb91a9c835e3e3372e53bdaeb3dedd87cc8eda56b5"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "12f9c13b9e3c26db850bace474d31be1e6904660a56e278008081f72c373ea62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d02daa563803d64b9f76609a35da042c2fc2b518d7dfa2b387036d16af119eaa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ffd7a5a97bfcb400265ef035eaca923ef4df023887c2887502027f392e1db99"
    sha256 cellar: :any,                 arm64_linux:       "439c2b7b4d35857af9ec389df68dd0f6408d3b123a56980e4efb6d0d992f91c3"
    sha256 cellar: :any,                 x86_64_linux:      "5e60d758eb76b3099a19c5ed5177f9b55cab978734ae2de31b1e03427cbbaddf"
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