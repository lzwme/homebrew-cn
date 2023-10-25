class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.7",
      revision: "8a688a5448fbadeb0072b1babd7905f8b276fb62"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7f2c89b5aa82d62c64e847f353f89e77959b35a63984d92f162d58bfa1b5e23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc1fce94edc5bb2258e35b0d556797762086f543436f0f4f1522eed72ff7e933"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f0793ff42e8cdbd47edcbed138ba6536acf4c6a4fdad43ac37887add9d38e6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "9cbcf9ac681a2c1c71f613f7e3a21f587403b91babc7f57072482a5b3a036c8b"
    sha256 cellar: :any_skip_relocation, ventura:        "ec0d12c9feaca5af7c253beb620ec0433a2217ef016a644701209e6827233dbb"
    sha256 cellar: :any_skip_relocation, monterey:       "a8c90d1d6b57c3806f5a3d7ffcfa55295c2538e08da41d4755cb489b85f81e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f81a80919721db23a1fa496d672565e51a120c58a53c5ff335f6f10dcbcfda83"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS

    expected_values_yaml = <<~EOS
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    EOS

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end