class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.18.3.tar.gz"
  sha256 "b6eb92e8d0acb2e3ab348b66a9cafb228ecc74a8392ce4fe0a8ef67237358474"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d6d226dd25b73a0e5c7977dbc9b13b5652a14452bd404739f7512fec1f25b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d6d226dd25b73a0e5c7977dbc9b13b5652a14452bd404739f7512fec1f25b02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d6d226dd25b73a0e5c7977dbc9b13b5652a14452bd404739f7512fec1f25b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "8933778fd17af70cdec9dda299de12ede1f8a3f7442e91ca5e180c274263cbea"
    sha256 cellar: :any_skip_relocation, ventura:       "8933778fd17af70cdec9dda299de12ede1f8a3f7442e91ca5e180c274263cbea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f06027621da3ead7fba5a3a909a06964c63d81ffb8a551fa0bf7736b356fc55c"
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