class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.0",
      revision: "950b2f38236c67cd5413f0020a3aab31285ee1da"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1517f6782883642eaba5d5bb593f896fc0cd79f19f99b4050c1b6d977b6a9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1517f6782883642eaba5d5bb593f896fc0cd79f19f99b4050c1b6d977b6a9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e1517f6782883642eaba5d5bb593f896fc0cd79f19f99b4050c1b6d977b6a9a"
    sha256 cellar: :any_skip_relocation, ventura:        "93fa114216434ea20a108c3d35c6d4e28309427e3da4b20860e3291b911f510a"
    sha256 cellar: :any_skip_relocation, monterey:       "93fa114216434ea20a108c3d35c6d4e28309427e3da4b20860e3291b911f510a"
    sha256 cellar: :any_skip_relocation, big_sur:        "93fa114216434ea20a108c3d35c6d4e28309427e3da4b20860e3291b911f510a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82a295c8d766de17403fe15357048ab65b9b6ecc905188001df71dd6c5f6b91e"
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