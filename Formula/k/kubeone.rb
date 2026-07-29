class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://ghfast.top/https://github.com/kubermatic/kubeone/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7d1e1b0a27a8fe652e0612d1b5827f1a7284a6e085339500be5e7769f17c1d3b"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "340fa0a794aa18ce691b543d4770e20062d274926bad2d35c868c6461a253b1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54028c1971e67a5410b6df4f5ac5b4a2c5ef0d23009b6c786a7fb9c90e9633bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eab25b34486ff2c79a510377b63cd9d65564654f924e2755c1e5e1cb91a62ec1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4934ad64ece6e7f6d21f4105deab45079bf6f0f1ce34ab0b50217a1763e33c86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "200f50b02e325764c3add1f30f1253b50d86a27190fdf94d32e04b1fba6f6409"
    sha256 cellar: :any,                 x86_64_linux:  "87cdd15859b2687d96bce77c299fba3ca82f1bf6c218e0920ed2b3f0e9cb377e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end