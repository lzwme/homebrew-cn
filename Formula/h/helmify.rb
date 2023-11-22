class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.4.9",
      revision: "7c69167c36765e2c0a8b158f22ab5c41d0dba01e"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56b723b4e130c8c85143760f014085ea9c71883b083c239204040fd39b8120e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ecf5f3074775b893b191740e46bd46d200177b3f1c27782d1f71f4abd8398da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a652984bc42810149e89cc8797dfaeb71d1655fb96cd914513e651fe79d93180"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec2635ce20f1868a667e3bab80a30a2e30437b9c26d8594bd7d393eb13f56bc"
    sha256 cellar: :any_skip_relocation, ventura:        "9810fd31196e38c3664c80033983b61e2daaab39b349e3a3d82ea5d938e5cbdf"
    sha256 cellar: :any_skip_relocation, monterey:       "c4ccd6c60b4ab6a5efdbcc624720f7d663e5df97182cf96f34247ed50380e8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1226dec419209b5234ba692c83ebb35e701c16031c3ac07ab7184da19c62e9e5"
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