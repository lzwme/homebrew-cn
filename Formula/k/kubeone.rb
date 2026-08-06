class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://ghfast.top/https://github.com/kubermatic/kubeone/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "45fcd1b1f41b5dfe35843e2ca8d674ea3973be09c34fc2c542ee7322f7f8d002"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e401a773dbdf7165fa3b5024bf2466c2bd753bbde8aa8de2ffcb11f3cf07006"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "466f3d953d979908ac64519343c72a0ba5578d2627493c8a7be5988a5761972b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce64fadeb554fe3caefa9078bfd9e46062a045054ed3b087af0a21ed4ed8838f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e47ed941bf4e657dc55abe7540c1319dbc2b696cde2b69d9ba8a7214ea2d3974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7907acd62cd51e85f0be83ec920f005104dd4ff85202f612506abd7627d3082"
    sha256 cellar: :any,                 x86_64_linux:  "b1a02d10b2a5522f67a1390cfb6b9e669c1d2dd78fa17d644216a114257c10fc"
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