class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.15.1.tar.gz"
  sha256 "ec6f5128afb7ff09ed0752d2af5e1e527763191dc603e4f5e750a0640514b605"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1cb558c2080e650ceada0cbd400e502680e780f6716265cbe5e5f2f51db6b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1cb558c2080e650ceada0cbd400e502680e780f6716265cbe5e5f2f51db6b67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1cb558c2080e650ceada0cbd400e502680e780f6716265cbe5e5f2f51db6b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "cad412defc4299ea4cdd71eac5ce91d3561433aad2e5d81040aa7714960020e7"
    sha256 cellar: :any_skip_relocation, ventura:       "cad412defc4299ea4cdd71eac5ce91d3561433aad2e5d81040aa7714960020e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f60c4f9d9b5334172e63b1d1ca00569881f3178e22b4a3e58dc243e177ea9ee4"
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