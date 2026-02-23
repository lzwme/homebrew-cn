class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/v0.13.3.tar.gz"
  sha256 "24842dc6fb260bcb08a50e5e7ef3e383abe9e809488effc22cfe9451c1c76d0f"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6de4f481a4f126df06d235dff848b99eb2e9109e4f19ba226952eaa139e0f944"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de4f481a4f126df06d235dff848b99eb2e9109e4f19ba226952eaa139e0f944"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6de4f481a4f126df06d235dff848b99eb2e9109e4f19ba226952eaa139e0f944"
    sha256 cellar: :any_skip_relocation, sonoma:        "133ae95a2c3d493ecfddd35b6eb229b43e65a326e2fe318daddf20eefd72ef57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5810a25adc51e9455cc4df4c24f6480ff667be522b118d19bd0534581376711"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbfe32984efb7b48b6d8ba20ba05e59b47e2440168ca9ddcd0cdaf7c04b589be"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end