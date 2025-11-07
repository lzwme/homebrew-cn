class Nelm < Formula
  desc "Kubernetes deployment tool that manages and deploys Helm Charts"
  homepage "https://github.com/werf/nelm"
  url "https://ghfast.top/https://github.com/werf/nelm/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "f1d8599d54f6b5563aca98cd730165009c50cba9c729fdad9cb7b34cdc8d580e"
  license "Apache-2.0"
  head "https://github.com/werf/nelm.git", branch: "main"

  # Not all releases are marked as "latest" but there is also "pre-release"
  # on GitHub, so it's necessary to check releases.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbc6743eece9ec5b986cfbe3a5861a688e0a947f8b53412ba92c11a8d490ca2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c54955f9a71b5ad4abcf4bed939de65ef2fef6b01b931e19ee022c4ac40d014c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6237e314cdd1949613c025b475a44895d8eb4477025b3c1be7cd7229d4b909e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff7e944c4c53a92f3bfad854bcb40b95816ca29a7ec06c75ef434f2195381b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "525bc79cae39c7a565397d37de22cfd9e3bcfe41aaa2c558892d1f94b11ef9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acbff2f93d3e9470a9bbf9d2761c17fa65fd8c5ed303cf7fd45dc11816671d57"
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