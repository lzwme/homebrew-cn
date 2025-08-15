class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "f054f1794dec773c325bdfed1e2f829189157e49cb3953fa575cb786771292a3"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9f817ad204db056a2e36d5a52e49654fd04638c85f64de57d461b8c3b9b1d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a606fd322a84c0a5ec1960dd5ea7699a2bd4d70db9d4e8ba7389f8ab597b85a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fb5fbbc4c012836057eec5f83ff814da7884646be3f1f993d6ff005e9a50842d"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a9828ce7d20e77b73cc16f476d156eee8bde53a17ee4ec687fb24d2a427e89"
    sha256 cellar: :any_skip_relocation, ventura:       "9b4ce8c68313f77dcc8181a38ccedbe1100e663a420a3e26e6fd5adcd141a958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9f7d9a14ac0d8b55d99c6339aabc5850eadc0eb90fa4257ef37ff042120b727"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b04217f110a037f5e2b175c62eb92bc9b2ce043b3e032280e0b18bf19b07d98"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/internal/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nelm version")

    (testpath/"Chart.yaml").write <<~YAML
      apiVersion: v2
      name: mychart
      version: 1.0.0
      dependencies:
      - name: cert-manager
        version: 1.13.3
        repository: https://127.0.0.1
    YAML
    assert_match "Error: no cached repository", shell_output("#{bin}/nelm chart dependency download 2>&1", 1)
  end
end