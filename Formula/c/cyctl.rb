class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.17.1.tar.gz"
  sha256 "164b38479d215c2d7c1d90eeb0b489f558c96fe90fe9e6d3af3f24c40ba1af36"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9b4f4183bd34ad5fa1087aba389872364cd1293afeef8eb97e5f61e8bef44d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9b4f4183bd34ad5fa1087aba389872364cd1293afeef8eb97e5f61e8bef44d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9b4f4183bd34ad5fa1087aba389872364cd1293afeef8eb97e5f61e8bef44d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebf93797d65ff55d0aa0099ccc70af4c034aeecaf37d46004148a10020f6d3f9"
    sha256 cellar: :any_skip_relocation, ventura:       "ebf93797d65ff55d0aa0099ccc70af4c034aeecaf37d46004148a10020f6d3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b38211c390f46f2ec107160957587f0b18b9e449988c445617a08e92a46a6d"
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