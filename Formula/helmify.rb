class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.29",
      revision: "81ba5a2d3ef3bb3967995ed85ac8d97d6c008817"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53e028ed5436977589345e680c0e382bc8b6ebcfa2fe26ca2f720c23df6fb5ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e028ed5436977589345e680c0e382bc8b6ebcfa2fe26ca2f720c23df6fb5ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53e028ed5436977589345e680c0e382bc8b6ebcfa2fe26ca2f720c23df6fb5ab"
    sha256 cellar: :any_skip_relocation, ventura:        "98dc5f9d1068c754d1126ae0357eb48ed43fe5bd788174e3d0e316f66a2100a5"
    sha256 cellar: :any_skip_relocation, monterey:       "98dc5f9d1068c754d1126ae0357eb48ed43fe5bd788174e3d0e316f66a2100a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "98dc5f9d1068c754d1126ae0357eb48ed43fe5bd788174e3d0e316f66a2100a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9453d44727fe38fe90776035cca5bffb3339033b8ddf4ff945b625ad97f4be"
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