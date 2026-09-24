class Kuttl < Formula
  desc "KUbernetes Test TooL"
  homepage "https://github.com/kudobuilder/kuttl"
  url "https://ghfast.top/https://github.com/kudobuilder/kuttl/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "bbac2d01871d6b411d30b8a391cb0b23a9a99e2b4495d1ebc0db1da44cef38eb"
  license "Apache-2.0"
  head "https://github.com/kudobuilder/kuttl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2589eff5ab615e102978884cab86c47ec542d8acda050c61a3d8f4a164c7b98d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c8dd3da380565204e085f86b85476ae518121e7cf2f6ef1fc955f2aab5b6e624"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0366e5944e21d022e1674f03312737ce0eba1a069cb412d0906b94ddf0fb7656"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17ef42ebfbfbdb3d8e6741befb010fdfb528d190cf5dd1b07b9c7792cdf15eea"
    sha256 cellar: :any,                 x86_64_linux:      "0fde0ccb427c5f09aaead29945863964bbf77db29dc7c4ceea6b5da1b753b07c"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    project = "github.com/kudobuilder/kuttl"
    ldflags = %W[
      -X #{project}/internal/version.gitVersion=v#{version}
      -X #{project}/internal/version.gitCommit=#{tap.user}
      -X #{project}/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-kuttl", ldflags:), "./cmd/kubectl-kuttl"
    generate_completions_from_executable(bin/"kubectl-kuttl", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/kubectl-kuttl version")
    assert_match version.to_s, version_output
    assert_match stable.specs[:revision].to_s, version_output

    kubectl = formula_opt_bin("kubernetes-cli") / "kubectl"
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
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end