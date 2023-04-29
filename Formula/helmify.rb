class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.2",
      revision: "3e87d86d3c6468ec33150d57f6f2c37de00b86da"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2f50dd72fb793d90189fa659a2d0bdb006474085b07cac9cff5299f02738ce2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2f50dd72fb793d90189fa659a2d0bdb006474085b07cac9cff5299f02738ce2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2f50dd72fb793d90189fa659a2d0bdb006474085b07cac9cff5299f02738ce2"
    sha256 cellar: :any_skip_relocation, ventura:        "9f24e00ecd05860a4d7fd90844cceaf147b80d85652ee2a253949b2e4db9e148"
    sha256 cellar: :any_skip_relocation, monterey:       "9f24e00ecd05860a4d7fd90844cceaf147b80d85652ee2a253949b2e4db9e148"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f24e00ecd05860a4d7fd90844cceaf147b80d85652ee2a253949b2e4db9e148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fff70eca96a7397db4f4c8a73989ca2c20f7d317d29a9e86e640b1595c2ec8c2"
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