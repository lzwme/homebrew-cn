class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.18.0.tar.gz"
  sha256 "8a1c1fab56104a6d1d8277758550ebf9461a332951526c58936276d0dd895a7a"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c042b3a0bef33eb9bf8321d455213a0b44d58debd960c149a54a7a999be0f90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c042b3a0bef33eb9bf8321d455213a0b44d58debd960c149a54a7a999be0f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c042b3a0bef33eb9bf8321d455213a0b44d58debd960c149a54a7a999be0f90"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecd0f900c7651b24cddaefc67baa37e63bedd7aa9e6b56c43f3dc83ebc71c9bb"
    sha256 cellar: :any_skip_relocation, ventura:       "ecd0f900c7651b24cddaefc67baa37e63bedd7aa9e6b56c43f3dc83ebc71c9bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d91d1d79d60bc0c2497f0f31db6d1d6245c985f14085698ff8ae206c2f0ab89"
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