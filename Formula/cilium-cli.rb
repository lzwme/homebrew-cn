class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.3.tar.gz"
  sha256 "359e26eab189171fd9fe720908df3f724c2cea007dc1fee36655c7ff996bd928"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3dee1d26c0e079fe92f12e2e34e304c3f234a9acd0b4afcd4152d40d78a88318"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "213d0066f9283a6cd3daf5e28d6e0769b51958c4ac427ae2e0d8fdafec722f02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19273682c18422ebff766ed617c4deecbbf9dca2f0026d189f10a0ad7acf0f5d"
    sha256 cellar: :any_skip_relocation, ventura:        "e8fd3cbdd1882e7159f1c577a47f758f166778914073c8f1dc271e12a4b16044"
    sha256 cellar: :any_skip_relocation, monterey:       "cd854d64622b59745d735e1dd0a2f582b6453a3e68f87a11635408ae267bbe21"
    sha256 cellar: :any_skip_relocation, big_sur:        "672428d8455fb15e622b85af6952433f6c593f85a1b06e9863324d616eafe3f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb73d67bbdc9b434caf4007251feb542a8c6b041c8dcab5013865ed8ff2ba61"
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