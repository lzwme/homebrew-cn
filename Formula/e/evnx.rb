class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "3407e97e6678feccee303f306d3e4890bd738460fdbb1a7bcbae3c2b69a15e8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb5767399c6d13cfdd110a86101b831f8dfe09698d2d987b9123b30151dcebcd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f03ea207b50301f4379907cddac682ef4bd209765384a4d72bc2bb4b64588dff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "87b47766035f13d95371d2c43f32cd0c9b46cfac2dfe19f3be2854d12732a378"
    sha256 cellar: :any,                 arm64_linux:       "95f2cefca8928d86714e87a3e7c7ff3c9a5bbd34b9654bb9e0db0630b585a581"
    sha256 cellar: :any,                 x86_64_linux:      "3f2ce8f9619f7faa49002e445deb8868ad5050115d736185495699ce9250dc6b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end