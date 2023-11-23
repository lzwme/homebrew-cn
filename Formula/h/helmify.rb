class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.10",
      revision: "909d091dd6771aee63b43a9df16c22bdc883ffb9"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5075832ddc784241e48db8ce95a59be574cc2907817e18cb07c94452f06621cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a552605515dcf8364f167ecc71aa7df60ea5c6977b5205e6664aaa01d6d3ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f788fc2f0b6a100557f45c209169080b68b27a525cda20c96697ba9bd8dd40ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c28091d36e2505511e60dc5e1f844011f6e97efc036894917165bbed223299c"
    sha256 cellar: :any_skip_relocation, ventura:        "c92a2a31d1b4993867574eead40e228a73c9aa20c19a89622895b312ff83e091"
    sha256 cellar: :any_skip_relocation, monterey:       "e1940c671e98982c1cdb6f51512c889a0de65d637255894c71952a076b9c5ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f7c9d9962cc0567efc8bb5b7c8bf198b05e49949efe87a03a6e1f7cb572cec2"
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