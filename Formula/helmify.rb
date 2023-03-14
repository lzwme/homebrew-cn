class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.27",
      revision: "0294e6b7124df932ed40eb2fa6afe2ab617ca601"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c10536c859389daee13c314fe64d53aac5fa7d1c0c593465c3f6bd63ed965c93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c10536c859389daee13c314fe64d53aac5fa7d1c0c593465c3f6bd63ed965c93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c10536c859389daee13c314fe64d53aac5fa7d1c0c593465c3f6bd63ed965c93"
    sha256 cellar: :any_skip_relocation, ventura:        "ee476fcdd54231bd9eb9be784a27b397fc94af5b20b1523c96cbf13f3309c2cd"
    sha256 cellar: :any_skip_relocation, monterey:       "ee476fcdd54231bd9eb9be784a27b397fc94af5b20b1523c96cbf13f3309c2cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee476fcdd54231bd9eb9be784a27b397fc94af5b20b1523c96cbf13f3309c2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "424874b6f3f4fc5733b6e1f9e23f84e5ee8308cc1156e934b6ff031241193c43"
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