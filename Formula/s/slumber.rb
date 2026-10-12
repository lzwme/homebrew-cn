class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "f32b4bbcb624ac6d8b05feef5326a19797c8fce62f92e1b6f5185b8f01bc381d"
  license "MIT"
  revision 1
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f5b80dab43d2a8ba50d898a886754d00118d7639c03f0e92f99b0f3de77cde82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c6384cf56011e7e92308e2ad07ce39d0fcad1f288ced6f772d8b60246513e761"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "465cfb03c73064995e48b2cf6c34190a831e3596b571aff0eaf27ab92036115d"
    sha256 cellar: :any,                 arm64_linux:       "9bce6dd7f65d6f1ca8e0a6a3595d0500211aa91ab491db7bf17d392f738c8b36"
    sha256 cellar: :any,                 x86_64_linux:      "caa5b45a7de83bb3cdec78122b97e72e68f87112ebedb0e65c33992bcd459833"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"slumber", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end