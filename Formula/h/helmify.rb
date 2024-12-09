class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https:github.comarttorhelmify"
  url "https:github.comarttorhelmifyarchiverefstagsv0.4.16.tar.gz"
  sha256 "0ae514fd567869747bc61ecaea336400825fa66ccb5f85b208f8831a2a001c0c"
  license "MIT"
  head "https:github.comarttorhelmify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295298a30ace6939a7fb04f569dffe3a9e1187fa29a16d2facb632a27b421df5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "295298a30ace6939a7fb04f569dffe3a9e1187fa29a16d2facb632a27b421df5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "295298a30ace6939a7fb04f569dffe3a9e1187fa29a16d2facb632a27b421df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "af33c2998763599bb54667aebb90f1ba0d12d79f0032d9d5bd79ce2f3bce1e15"
    sha256 cellar: :any_skip_relocation, ventura:       "af33c2998763599bb54667aebb90f1ba0d12d79f0032d9d5bd79ce2f3bce1e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9dfe2db85fe47a3a27b6f637779e70cb8e502d24130d8b9aae53568361560b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdhelmify"
  end

  test do
    test_service = testpath"service.yml"
    test_service.write <<~YAML
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    YAML

    expected_values_yaml = <<~YAML
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    YAML

    system "cat #{test_service} | #{bin}helmify brewtest"
    assert_predicate testpath"brewtestChart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath"brewtestvalues.yaml").read

    assert_match version.to_s, shell_output("#{bin}helmify --version")
  end
end