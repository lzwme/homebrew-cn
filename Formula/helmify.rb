class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.34",
      revision: "2d1d959cc147a9e23bd7dbd5619315649c205ecc"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1928190ac28942c0463f7175cb819e02933229745057d3cb8ecfd7a2080042d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1928190ac28942c0463f7175cb819e02933229745057d3cb8ecfd7a2080042d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1928190ac28942c0463f7175cb819e02933229745057d3cb8ecfd7a2080042d9"
    sha256 cellar: :any_skip_relocation, ventura:        "80a0e45cfdf2ef9f735eb896b22d52634aac9a7ec4ce6530ecf43491abbf69b4"
    sha256 cellar: :any_skip_relocation, monterey:       "80a0e45cfdf2ef9f735eb896b22d52634aac9a7ec4ce6530ecf43491abbf69b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "80a0e45cfdf2ef9f735eb896b22d52634aac9a7ec4ce6530ecf43491abbf69b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6643f8342b61350e8e8b24749f806bd63ca6bc33b4056c99d83eb4cce1241f3f"
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