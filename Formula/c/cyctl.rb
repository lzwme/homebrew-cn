class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.14.3.tar.gz"
  sha256 "0b5fe70b86e6ac444ca5842c9b4ae57b21f5576560c768c7ebf37cd197ed7aed"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "768e40e1e1ed675acac73e81d8298a91efb2947b53df987789211d2a8feca682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "768e40e1e1ed675acac73e81d8298a91efb2947b53df987789211d2a8feca682"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "768e40e1e1ed675acac73e81d8298a91efb2947b53df987789211d2a8feca682"
    sha256 cellar: :any_skip_relocation, sonoma:        "3711d7ae1a42be74e3c5ed4526a94a5e935590e98204e27bb4f69e692cd99d63"
    sha256 cellar: :any_skip_relocation, ventura:       "3711d7ae1a42be74e3c5ed4526a94a5e935590e98204e27bb4f69e692cd99d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bf5fd8fa6d6f0d7bd983156359db26ec6dceda503bcabf23c8a16ab5474efd1"
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