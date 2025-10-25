class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "fd7a8fb774370070469a6faf1c3fc5ffe2ccf1d8ba3952f2306bc8cdc779bc98"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53499c1b6533a981e853ef961ea73c991a1f5ebfc2f67dad711d388313699b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9302b2a6540d053f99ba7485ff8029041d2c1930b70f71735c7650f71658d83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "174c48299d404686eadce7b56753bfd865b28d3901feae7fd13d9edc1b883dd1"
    sha256 cellar: :any_skip_relocation, sonoma:        "44ca5b87141ba8a92e4c8d99b0c4c419367b6882810ebe518a015e142cc97aba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d151fd36c408690ed85e675769dd814f03be3aafd51cfd72d8e9cc1f8427644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b88ed6e38c9255953da7a041ba207ab08a130e95cf8283a42936f0af6c7d42"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/werf/nelm/pkg/common.Version=#{version}
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