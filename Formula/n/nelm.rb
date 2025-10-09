class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "623b2455dfb66314862c31c16873492a1710332f8f0155fc1da5a08bb1d40c96"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbc59b4207cb66857a3068b09a2b3e95b2bbb3b7eb25b7f05bd3d7632d260696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a3d6a5ff83b61a4add0fa5e13309ce078c109e6ce743018df8b4a28babd0f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afeab8b1dbd0ac84b577aaab0f7ccf5a3850601e4119784b195082817e5ab09b"
    sha256 cellar: :any_skip_relocation, sonoma:        "79f72a3f75a570bfddf28bc7e59c267632cbb875e4b4ed71b3db1db0f4e71565"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c84f8d6223db7f1b87f580a4c9ee9974742accd3ada909fe7e633b9e0488ee54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37d8e35cace85e197914dcecebb858c3bfe72832f6a466ea4cfd054c05283dde"
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