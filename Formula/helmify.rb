class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.32",
      revision: "64081304dcc4a5cde8e0c038c78ebf709f95ad6a"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcfedf1bda037ad47aa1844154af22990b7ff017489616f81f95a50f7d381bdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcfedf1bda037ad47aa1844154af22990b7ff017489616f81f95a50f7d381bdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcfedf1bda037ad47aa1844154af22990b7ff017489616f81f95a50f7d381bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "e2d2471dd341f1e66655ce69bfbe8a6e584eb9b83bdc48462d3827f179e61383"
    sha256 cellar: :any_skip_relocation, monterey:       "e2d2471dd341f1e66655ce69bfbe8a6e584eb9b83bdc48462d3827f179e61383"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2d2471dd341f1e66655ce69bfbe8a6e584eb9b83bdc48462d3827f179e61383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86fb1de795a1e34d8e7b19499c3e28f271e343400492533a4de7b7a9981f8a3"
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