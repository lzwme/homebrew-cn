class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "fe68a6613b16854cf17ffcaa9db3933e9c90dbcd0c842bb05f382e5560084b82"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a43a607596c2e9db187d38bca29db45e9fc4bfcc2ff9ce440a6496a64613f1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a031c26285c604d6e71770629780c0de0915b49b37067e3037016872ed9fa9e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "091bed1332ea615ce02917519e09b44e0ae0a1e5b11f2c40b1c503138b626aab"
    sha256 cellar: :any_skip_relocation, sonoma:        "086fc04c290e513494de6009cf5e6eec9d235618c2259b006f05312b0e874e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad5f40aafbf51ec47d77094828933d635609deef9961b295d930f84993a7df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0234453d0a0de93c57d08a66763a8c792bcc698b1fc7a9488de9686ce22583e9"
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