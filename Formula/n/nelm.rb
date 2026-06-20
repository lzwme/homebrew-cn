class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.24.0.tar.gz"
  sha256 "94b0ea16cc216a8f31376f5d5b7059c10f844ddec010d18b1e54296ba14816a8"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07ef8d1d6d2bdc2274e5291353ce0853483702a6c51c7746e305ef57ccf27377"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19f13a44529d299aaf0bcad60a9fda61398eece8337baf568901f444689c42a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9af836f6ff3b849cd7c6c3ab05fba730f2a1af5d63449a0010e6b20ab3fdc383"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce7f9fe8e57589f097073e2e0bc03b207a63bd55fa663c0acdb53ab0d2ca4799"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a284e3dec2d3b54adfdcb429cf497adcfc42f00da740c22119405cd0fd9a621"
    sha256 cellar: :any,                 x86_64_linux:  "85cc53e49209d3b84212e46581e17d56622ea1350d89137d32d351a13bfc1341"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nelm"

    generate_completions_from_executable(bin/"nelm", shell_parameter_format: :cobra)
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