class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.15.3.tar.gz"
  sha256 "17be692578d2d129001aaa9fadc03e6d2cf32d502a4e499bc0f4c5fce197e4a7"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e3ede476776fa00e0798dbab3c6098ba47717bddccbc28d41df19df3a7b888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e3ede476776fa00e0798dbab3c6098ba47717bddccbc28d41df19df3a7b888"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d6e3ede476776fa00e0798dbab3c6098ba47717bddccbc28d41df19df3a7b888"
    sha256 cellar: :any_skip_relocation, sonoma:        "c944193c7616dc221739475acc6bd691992caa2c5ce6ede1b7ded87c151ed7ec"
    sha256 cellar: :any_skip_relocation, ventura:       "c944193c7616dc221739475acc6bd691992caa2c5ce6ede1b7ded87c151ed7ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37463d706bcf80957910a6b685741d56cd77d47d8c717fa4a98d5040297c8819"
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