class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.68.0.tar.gz"
  sha256 "820bdc294f1bf0e1f08d662d7e845a7bb09f4cffefa662fe78e8c516f3a6212c"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d1a7351a40c9a80ba6299168e925847a93287a2f1aeee5f923379eb33cc03c1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7a55def5db8879353a47e1df8f265b95ca0bb4dc1fbc584cfe1f1dd2274ed9b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8661b78ae5726dc589ad9e0a3f1749f199e2494b1ef20af84c51d47e44a793ae"
    sha256 cellar: :any,                 arm64_linux:       "3bff23f9811fb915d3759a0903dff69ae7bd41ad05b56ee3faa4e653e7438bf4"
    sha256 cellar: :any,                 x86_64_linux:      "29f33531533c331e0356be341a5fbb5fcfd945029dc8415741499d99053bd211"
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