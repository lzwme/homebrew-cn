class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "e940a30340249ab3934ac695a0e322b33d59468405ddb6ec1c75a78062ccef58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44d21a1ed476f5e6cf30210788918e920a6f0f3d95c642077fcb16ad07a42960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1b6540756d831b33f2e5b811fdc5a1c6f920b6f67aa3c53904e74428ffa4eb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47e8f05b136cae0f16380d518dbbc5654a2c3add0bc2b1571d5ca1126d7d8e8d"
    sha256 cellar: :any_skip_relocation, ventura:        "7fd629d0e04ff553d168544609d4fb21bba6f6653d380b1dc4430950046f8adb"
    sha256 cellar: :any_skip_relocation, monterey:       "1973aeacefac4dffe5c001a2f83feead2d947f42ffb9c93579564caf48e35e3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fbd5bc880be486c93f9c61051fbbdec75265bdb8331f3f15f8aaf20b90eb7ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640b9bdfad1b95878f05265bea029b3a3009830c0af40725990df84e2dce2228"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end