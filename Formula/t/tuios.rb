class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://tuios.gaurav.zip/"
  url "https://ghfast.top/https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "7c3640d22c3c460f843a8deb75c7c85ba1bd568a80390d5879868d79b8222181"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8e54b6891309c28743139864dab066e3fa4bf3cd251d3e3be1f63081001423eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f34b9b0a1b2e00063ae5c35d224959a7e5ae8122100a35796607eb9aa9038674"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2e161baaa487c6c7da19282e97817615e5facaadce63c98c32165b6f5f371b0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bcdc6291e7749c97029486810b3a82735a530484f202902140992b71de17ccc4"
    sha256 cellar: :any,                 x86_64_linux:      "e26de2674a390566d2d9f67ea964c1e91daac017b563c68bc4065aa48a22cf72"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end