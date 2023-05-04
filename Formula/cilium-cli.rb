class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "f9d816292ab46095e4d6eac043988d10a94d4ead7a7105c429966cdedfe6bbe4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f4c99b52107f8513cc31522601866a5544a9afa7da06dff861612778bdab7ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f8b1bf22472dd4afef19e3abf60d3544af6225550f6bba2372e2cf73315d9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "314ee4dd7f5e6e3daffbef8d41aa084296f2cddc3a2348ec7b4c5f8b55988cea"
    sha256 cellar: :any_skip_relocation, ventura:        "a178d1fd3a745e975b3d101148d803d641739b8a5fa0df496e6364f906aaade3"
    sha256 cellar: :any_skip_relocation, monterey:       "954905fb529fc249a38eb34942a7d75e5c565a53ce5aa1e61653e34ae4f14999"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c438094e1f247470aeee3f252c9d099e30ed6ebbe07b1747c072fac798312ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0e03ff8981f079cc00ca5be5fabf6a16eee33a3e31f484f8578c8916d658bf"
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