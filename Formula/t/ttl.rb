class Ttl < Formula
  desc "Modern traceroute/mtr-style TUI with hop stats and ASN/geo enrichment"
  homepage "https://github.com/lance0/ttl"
  url "https://ghfast.top/https://github.com/lance0/ttl/archive/refs/tags/v0.24.1.tar.gz"
  sha256 "7093ee7bd8cb0f10cf391b2c1842463ac84f7823ca6e0f998cd8932de844c17d"
  license "MIT"

  head "https://github.com/lance0/ttl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59f1015fc9b7835b7580ddbe50579af68c2ceb7500b0fb9de24034d03d6c541e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fdd5a009dd73f5224a759edb694a0cc5ed04871bbe13f2a6bbd19c621a036b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "be450f738cee7af0315e01ee82d84caa67ce689ab05903b40896397cb78123a9"
    sha256 cellar: :any,                 arm64_linux:       "f91e47a7f426674755faf6a56676f27bede878f92394678bb666fe30cec6eb72"
    sha256 cellar: :any,                 x86_64_linux:      "35a9071e498e292b7e259dff44cc4669fe43d11776bb7cbdd76cc6c9905b06f2"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ttl", shell_parameter_format: "--completions=")
  end

  test do
    assert_match "ttl", shell_output("#{bin}/ttl --help")
    assert_match "Insufficient permissions", shell_output("#{bin}/ttl 127.0.0.1 2>&1", 1)
  end
end