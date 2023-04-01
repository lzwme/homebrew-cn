class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.35",
      revision: "0126096f81d7d7c585e525d6555913b7e46598c5"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c63d9450cd41f942d7bf82b08593194f29e9da63efd3d411d821847b724b71d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c63d9450cd41f942d7bf82b08593194f29e9da63efd3d411d821847b724b71d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c63d9450cd41f942d7bf82b08593194f29e9da63efd3d411d821847b724b71d"
    sha256 cellar: :any_skip_relocation, ventura:        "6053bea642036f1e1c75de1efe8295db7a883db4867eebea6d520f2f00ac8f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "6053bea642036f1e1c75de1efe8295db7a883db4867eebea6d520f2f00ac8f6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6053bea642036f1e1c75de1efe8295db7a883db4867eebea6d520f2f00ac8f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4068b9ecb9b3e8ba052971e5bd7672da1284db026e99df8ce59297616839373b"
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