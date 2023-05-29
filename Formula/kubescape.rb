class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "776701cc131f3755dde88b2eddb49917b36d3cdf0bf4cf453cb3eb742b73d7d8"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a1a7116c42afae8f3e3212a3d0532b1439ff5254fea41ad6905a5f5c4be2670"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13a345a072a8e1e89189a70b25444dcb82cbf5ba9e4b205fec535e3d32f60e99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a33d87830a38d8e7ada7afb97a0390f3242ca21d10c6efa787b2cdb1bec39a92"
    sha256 cellar: :any_skip_relocation, ventura:        "6924b6ab616fb3f402596d97a07b72dc2335d846387b2505e3cc5e5ba6ed75d6"
    sha256 cellar: :any_skip_relocation, monterey:       "678e24281183552bf5f44420b9db341ad5d063250a7b3bf4fd10a553608ad51f"
    sha256 cellar: :any_skip_relocation, big_sur:        "15739bf6f28a41ae820ba1c853440c7eee63af00ffc98de0650bce8d969f47f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c1b521b16d6cda06d95d93ca58ee87b610b248f830c9c565ae2f666dc63106d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://ghproxy.com/https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end