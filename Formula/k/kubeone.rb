class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://ghfast.top/https://github.com/kubermatic/kubeone/archive/refs/tags/v1.13.3.tar.gz"
  sha256 "89e3a5ed4a547a416972b3a6bc7d1914e4c2c5917d71514bafce7f2554602c0f"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "699a139f4eb05efa93e5859f59242ca155f4f167383754243d15edced27cddf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b58075f9f7c656537e541e68cff8f6fcac4c10fb5d3ea32985171b45515ee00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20d88f59dea479e69348f0b88ee9771f5502df3c22ad4bd5b540be7ff42cd0b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eef5e5f6202cec612101c42261996c55bd07f93b64a4c0fdf2f18a453804c0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f12e8283197baf1b59c7ad55443aeb7847dac14883b4b9d088e69d558d0ed8e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2917e615bcb8003887546ca8edaf81a0e8a9568df1e46dfc7018b69297e38242"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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