class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "0355888725e84e526ab92aec616a8c08b4d68b809db70ccbccd468f6a87c114a"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faa6dd442213a21b63198409ba2b94845a3ba5c8025d87520e8a991a7b4d5d93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96f9233b74f5ea90d7e607cb8cf65048857de4b066d52d352da4190fe6c5b601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "833786709a815d3269ee5c0f510650760da170fad9a9511d8282b7fcd762d89a"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e5c8db852be4aba2d6047de68da7c5e3a3adad24caf0c1e77d49e7cd10a8fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f17d447e9b89c0d15a2f397f014656dab8ce1820c2d181f168a6f8decf602ee0"
    sha256 cellar: :any,                 x86_64_linux:  "357799f89d55cf1cebba0ed6561c64f615d868be420ee5ca8489d58ea8cfe5e3"
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