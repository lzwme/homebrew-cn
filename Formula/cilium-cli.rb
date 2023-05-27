class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "eb1c88eef24425551682592e7a6d128fde659f2f7b69de10e7edb5e8806916f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3f0a5b2818ddd437d29233c1ee0fc550908f5a4cb9ff014a14af8196743759f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46a249ee1df0b4e0704b6e8ee09ef19062f9d5607aab566b51580a7c42d126b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11376ee092b5f674d249ba457a29e1e683ea3008763961ebef78932a454750d5"
    sha256 cellar: :any_skip_relocation, ventura:        "bf8634571cc4ac23c10df7e9b3d6c2d762cde841f9ad1aac57134c995c5c58b4"
    sha256 cellar: :any_skip_relocation, monterey:       "e2572a23a39a7e9f2ad3b795c5ef1c86c3d915ce003cd545ed909e7249936055"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6283d271b8dab5c33bb5381c233c298b39fe08b561d58e51d186cfc0a8fa492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49817f7e410f096d269f078dff0471212e5eddd24f07b8eedf53f93ad96ff69"
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