class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "24748d17cb54366c8fccbdf151af71366420b34201fb8d197854b9e601278a63"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50316f6e6606085f6c710f470a9158527f4dd0f417be65b6882fa9a305124cf5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1584de113829fe5539a0d9ae47109d002eb7a351ac3562096d8869b303646532"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "103bf0e8613a1392baae5c2309bc21cd3b64fdf00649f52aa7d7ff1aaac56836"
    sha256 cellar: :any_skip_relocation, ventura:        "4aba04e42130f67d7d46d7dab50b42428ed9f3ee158de60c546709463489794f"
    sha256 cellar: :any_skip_relocation, monterey:       "8da19ef9cfdb8f6e388d0a5814ad4217e363158d2c1d5f442e7a8fe5faa39cff"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a105f225a9c246eb7a4a63a8ec884e7af79f2a30e42e14f6b225c833a59ca33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ae0f2134a1daf5692bab34e93d90a4a5efc60934a6fb88265247db1f2551b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end