class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.15.5.tar.gz"
  sha256 "d89be91c342d6299be369725aaec333b7cc96ebfa136d11239515ca0ded9a387"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1a77eacba7cac2d8ec4fa698d05e23df36d83b76a0d7c9dda0771c473fae3c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1a77eacba7cac2d8ec4fa698d05e23df36d83b76a0d7c9dda0771c473fae3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1a77eacba7cac2d8ec4fa698d05e23df36d83b76a0d7c9dda0771c473fae3c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "03957bdb45168fd83f9214dccbea65b82f52daafb1f7d71adb6fc48ea217b261"
    sha256 cellar: :any_skip_relocation, ventura:       "03957bdb45168fd83f9214dccbea65b82f52daafb1f7d71adb6fc48ea217b261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cde86233e68fab1208f93fc74969832648e2e1cef36c3272d3f70782bf44fcc"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcyclops-uicycops-cyctlcommon.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}cyctl --version")

    (testpath".kubeconfig").write <<~YAML
      apiVersion: v1
      clusters:
      - cluster:
          certificate-authority-data: test
          server: http:127.0.0.1:8080
        name: test
      contexts:
      - context:
          cluster: test
          user: test
        name: test
      current-context: test
      kind: Config
      preferences: {}
      users:
      - name: test
        user:
          token: test
    YAML

    assert_match "Error from server (NotFound)", shell_output("#{bin}cyctl delete templates deployment.yaml 2>&1")
  end
end