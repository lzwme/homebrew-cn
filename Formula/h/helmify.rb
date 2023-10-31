class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.8",
      revision: "0b64abb651cc07212596451bec33cfc804db85ed"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18ea29e6815e7c9adeb8d320a976cb43eb6ce5c5fc343e9bd7e153e2d368eb5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5ac2452ffc5ae6923863705a90ce505dc9d6137e50c70d1e73b74606ada23c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e95ce6d62338918a116140d6f29b6db44dadf50577e76dc5ecad1c8e2f9fbfe3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6be635e0921fd298ad27c68b3dbe586359ff39d8b5fe61315550111f30577521"
    sha256 cellar: :any_skip_relocation, ventura:        "6e86b2ec1da70dced14e670fe7e67736315fa21981346c075376e717a4ed7eef"
    sha256 cellar: :any_skip_relocation, monterey:       "74ac4e8ad1305aeb98256925cdd475d8711fa81855ae6be0c7ef124922f1692f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05759dc3dc5ce9c1e4764cb44d2cd4c5e4e40067496bc59a38260ecbe4e3693f"
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