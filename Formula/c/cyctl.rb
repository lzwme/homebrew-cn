class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.8.0.tar.gz"
  sha256 "2eec9dacea78f79687e99d84d3840762733af92a3011297d4d3f9c8197c9f985"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f550fd7297f849690343be4da3baa6066d7ec29e4ee4f2744f032f6b89ae4760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3757432034ecb27a9f0ad1909583b108c1c377087a181b0b99edd60ad3517928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e733dea55c4e1d0825cbab6122647a6adffb910fe981b7fb598b2ff683c6164a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0e5231cff3a9df0dbab3ce06cb0fcac575b8e58ff37a9578b65c513596feae4"
    sha256 cellar: :any_skip_relocation, ventura:        "9decb4498695666532e75d6d0e7b5517b244832f660fe3e839194223d855345d"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce07e5703caad580dcf9f0cf3607a42725bcff86efa3da4ab7ae743d5d98157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db697fd7260448236a5532efcc23e9bf16e86477acf1eae55e784974734951e6"
  end

  depends_on "go" => :build

  def install
    cd "cyctl" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X github.comcyclops-uicycops-cyctlcommon.CliVersion=#{version}")
    end
  end

  test do
    assert_match "cyctl version #{version}", shell_output("#{bin}cyctl --version")

    (testpath".kubeconfig").write <<~EOS
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
    EOS

    assert_match "Error from server (NotFound)", shell_output("#{bin}cyctl delete templates deployment.yaml 2>&1")
  end
end