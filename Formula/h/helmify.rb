class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https:github.comarttorhelmify"
  url "https:github.comarttorhelmifyarchiverefstagsv0.4.15.tar.gz"
  sha256 "ac97c908bdff14effc63e1efccd6c092c3e55d8fe55e057e22aa1d2b6e7b3f88"
  license "MIT"
  head "https:github.comarttorhelmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49049680b146d366f8efd0c25b6fc30edb3823378baea332556e9de5108af7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49049680b146d366f8efd0c25b6fc30edb3823378baea332556e9de5108af7bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49049680b146d366f8efd0c25b6fc30edb3823378baea332556e9de5108af7bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f212835f992c3abacd45d2b5ef266fd96a2a169afadd2704f6b18628957e01de"
    sha256 cellar: :any_skip_relocation, ventura:       "f212835f992c3abacd45d2b5ef266fd96a2a169afadd2704f6b18628957e01de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b16282700bfb5f8452b16b1e090f91d7e100c454bd2467c002cb4dabfd84b710"
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