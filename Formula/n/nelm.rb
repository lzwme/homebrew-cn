class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d956d2190c185cc18da8b17fabd2091a5c6855e3b4069f4324a2c6fe77e84a1d"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d856037beeae00a9a5b592e9c8c8deff9ce105613c770a357ec8ddb9c32e83a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13e43f7c8da6aee34b1003af70497c6fb0741364e55968431f516934ba9c93dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "09e559c8f6cfb5cc25f70ab17e6bba56e0cedb5977f3f3c5e12f0d96fd18d24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f4298b07a519857f1a733445c33dd7952f3ceeccfc12c909bbc26e0c37f1ec"
    sha256 cellar: :any_skip_relocation, ventura:       "ba52b3015399280a6ec4b3a4191bb810b7d3cba6513f08c2e149b0b74ba53ffe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39e6c1446c1a055a8aef39b2429eef83ec7ab5289358b04ef1210b6ea09fca0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04aaa5b3cf927a805ad262a691bbe291717eae0f6d7b4a5c219ef52c7ba6c57a"
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