class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.15.0.tar.gz"
  sha256 "041f963cc2e261e976a6e2326ca2ff7186f37152dd94e7ae299f5e3c01e22bae"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2963cf3aed3c388d1df7c97f1564c9b7d818c1d4de9d64b818d11ae90d986d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2963cf3aed3c388d1df7c97f1564c9b7d818c1d4de9d64b818d11ae90d986d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e2963cf3aed3c388d1df7c97f1564c9b7d818c1d4de9d64b818d11ae90d986d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "db0806ff406593068c9d8ab1191a2cf88ee067849bfc23ff7a72fb770f816bfa"
    sha256 cellar: :any_skip_relocation, ventura:       "db0806ff406593068c9d8ab1191a2cf88ee067849bfc23ff7a72fb770f816bfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991b0a361b3da0e4d33691ca8204cbe6351c95d9218cc3f6beb87a8087f59225"
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