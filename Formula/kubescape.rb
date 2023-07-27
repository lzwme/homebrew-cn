class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://ghproxy.com/https://github.com/kubescape/kubescape/archive/refs/tags/v2.3.8.tar.gz"
  sha256 "f84e29e2c5416f65d1b2146d129a745703e6b379b1a17a0a4a805b594f9d47ad"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15927b380685ba677463649c13236d4827f1409a4e872a819eaf386b18de5f7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20e6cbebd0b5368656c489df6669ac497b924d9c07105bf2f35685b59cafca04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6cfeeda66607da2973056dbc1e4728434dfe0270a9eefd11a1d0642296334cd"
    sha256 cellar: :any_skip_relocation, ventura:        "d04b96420e688471d087151a77473d380df96e2460ac4a45c813d06b41b4da59"
    sha256 cellar: :any_skip_relocation, monterey:       "361c81893441c94d3968a2a05bb124641e5e6bc90de7761ceb4b21b2c99e3b2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bea8d30671cdb0ea087695a5c5d236bd760ff1c152788fcc47a2bd1ad44611f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5210e248f2699ef9b0e74f2e7d170bf5aebbc0915b42ad5673d4fc8a69429e25"
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