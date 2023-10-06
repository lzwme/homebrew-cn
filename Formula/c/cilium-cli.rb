class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.9.tar.gz"
  sha256 "59952dafc7643254d692dea8b1c3fb268ac2674d19ad7ceb5e384ffa396354a9"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7183089a507df79062f7f0471e25e32ffcd3039bf84533daef8b3b432caac9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5228579304e52f0f6140995da17919cff52f8ebd15e3bdac608613ca92cef8da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c95ff55fe5e3ce625472f6615964bcc836f2dffd533817220a926f2e34d0151b"
    sha256 cellar: :any_skip_relocation, sonoma:         "efbcd28833afa0aca5d790c05c9aeb1c69be43f1a8d5b717bc3eb85b6323cbc8"
    sha256 cellar: :any_skip_relocation, ventura:        "9520af3764823f0d078a7b4ca5cb184ff78c517701ddfa2b543c3e18cf024da0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b6bf02ad7eb5b830db101d016e48c4fe117c9b7ee781be6d28eb3963caea6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06ea2e5c8090a005e0330d1c22af62140d782dfba3d20e82ca8a1bdb0db30f78"
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