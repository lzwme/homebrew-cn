class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "8f6bf170b7757fbc8731aac52b8332e2851bd9c2739bcc54f33bfc5a68da568d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa2390c2cfb4007d2a6ef617156cc6fd5e6f6adfd2950373f40ffcdb09dc3d86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0efc87de1910a95ca476085187996d1504bca2e1e66afbfafba922ded05d5663"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80b246045a55890525301886b402a7734d0663d2d1508ed2906857f71b61a370"
    sha256 cellar: :any_skip_relocation, ventura:        "29e940c6de734ef8521fc1c50736b49fad0dee6bb684e8a37235e8caf35b3e06"
    sha256 cellar: :any_skip_relocation, monterey:       "4456df43745330938bc263eab5d9452ecb682e7106de38be2313373135dcf58b"
    sha256 cellar: :any_skip_relocation, big_sur:        "10541ee25744f7fa1516c73757f3ca04a9529ba5b2885cde9688740f5d788fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b20a296c58ebd6dfd1b76b976357073ba9a0b1e74c792dfc15acbf25b4ec38"
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