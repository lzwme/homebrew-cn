class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://ghfast.top/https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "d576b1be8294451a53dee27e9c95b814d2641573bd4a1963de468498347802cf"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5311fc6c89e0cb5b80873a401b15c3f93f350efb00c7d3a4f00ae92ec54d19d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b70d0387e6b5afd9ec4ad4965a5318e54815213cc8d4f50ce2a57cd8d92ceb1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14dfff13d47e3fc30c12eb10e1263361d61303a6f3241e978bb980c570528305"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b28be46971fd3d76ee66d9a02d2942a1244328e3e8d73c63d1d19a4803190c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ea07f76db88a1974c989fc5dc4051b30d8900ea96a9278b21c5898c3cf95bab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "839c2f0241bcfda2845f572a40cf6acc83cdde40bd2a5adcb3ef3172640f7bb9"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.gitVersion=v#{version}
      -X #{project}/internal/version.gitCommit=#{tap.user}
      -X #{project}/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-kuttl", ldflags:), "./cmd/kubectl-kuttl"
    generate_completions_from_executable(bin/"kubectl-kuttl", "completion")
  end

  test do
    version_output = shell_output("#{bin}/kubectl-kuttl version")
    assert_match version.to_s, version_output
    assert_match stable.specs[:revision].to_s, version_output

    kubectl = Formula["kubernetes-cli"].opt_bin / "kubectl"
    assert_equal version_output, shell_output("#{kubectl} kuttl version")

    (testpath / "kuttl-test.yaml").write <<~YAML
      apiVersion: kuttl.dev/v1beta1
      kind: TestSuite
      testDirs:
      - #{testpath}
      parallel: 1
    YAML

    output = shell_output("#{kubectl} kuttl test --config #{testpath}/kuttl-test.yaml", 1)
    assert_match "running tests using configured kubeconfig", output
    assert_match "fatal error getting client: " \
                 "invalid configuration: " \
                 "no configuration has been provided, try setting KUBERNETES_MASTER environment variable", output
  end
end