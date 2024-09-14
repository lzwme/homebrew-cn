class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.11.1.tar.gz"
  sha256 "c546dc6ba3336bc683b3c4952fa4a97ba7a1df88121761cb0dfcc505ae89c031"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cda3e459957a2c80fa84b5d58888fb9d296a9789593d9d6098f90ce7aa948373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cda3e459957a2c80fa84b5d58888fb9d296a9789593d9d6098f90ce7aa948373"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cda3e459957a2c80fa84b5d58888fb9d296a9789593d9d6098f90ce7aa948373"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6291a2b993c4de286ea4a466b9fc1ead7407491a44f882b1be8ae94c2db4190"
    sha256 cellar: :any_skip_relocation, ventura:       "b6291a2b993c4de286ea4a466b9fc1ead7407491a44f882b1be8ae94c2db4190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68ceedcb024140e84fb47a01fa197126dc80e8fcc816a8a0d3a4b1ef695b6ed0"
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