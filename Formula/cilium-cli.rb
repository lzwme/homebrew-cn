class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "186eaa0a29a8029caf0944e357584efcb0434f89ecff4889f3b18c0a91123445"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56f7504708ebdf75a24d259a352c4badc7acf0d0d8e32aeba53f8dd21da78ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "336bd4d81b07d5d9eaf86266654654e2b6830bffe68a8ecb2a00ae6bb07b5f7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b607113e5d2fc7f5be6034bd0d98978f8dd9d045ee0ed55afff91c995646535"
    sha256 cellar: :any_skip_relocation, ventura:        "3d873c2d2103edd1891ae3fb963efb8c39490d3e59c2dbd46bf30b3fe84c1f98"
    sha256 cellar: :any_skip_relocation, monterey:       "8c87afef9497f28d67400087e67f16daf6e439bccd3a90ea53afca81ff5f546d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc2c9134f1cab0df42c561e3b6a4625c6799d40fce57bffbb78f1c4b83b4708e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ee71c1b73662858227383e6c0628f9766631785e0588d3fd4c2434c6dfd977"
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