class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https:github.comarttorhelmify"
  url "https:github.comarttorhelmifyarchiverefstagsv0.4.16.tar.gz"
  sha256 "0ae514fd567869747bc61ecaea336400825fa66ccb5f85b208f8831a2a001c0c"
  license "MIT"
  head "https:github.comarttorhelmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94001ab1feebadfea7ab6b1268afd5634973ed2d2f91e1627d662f17a010dbaf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94001ab1feebadfea7ab6b1268afd5634973ed2d2f91e1627d662f17a010dbaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "94001ab1feebadfea7ab6b1268afd5634973ed2d2f91e1627d662f17a010dbaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "4329c16ff2831c60ba135f5d67d60d676b1579f1c193ebc0312f39f9160f7ceb"
    sha256 cellar: :any_skip_relocation, ventura:       "4329c16ff2831c60ba135f5d67d60d676b1579f1c193ebc0312f39f9160f7ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4f1b4b4cb59cb25fe13440a86ee7d4e0c447b69e5ce2a90d5ce19edd2c57142"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhelmify"
  end

  test do
    test_service = testpath"service.yml"
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

    system "cat #{test_service} | #{bin}helmify brewtest"
    assert_predicate testpath"brewtestChart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath"brewtestvalues.yaml").read

    assert_match version.to_s, shell_output("#{bin}helmify --version")
  end
end