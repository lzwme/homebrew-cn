class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.16.1.tar.gz"
  sha256 "6669b46e22d9e1b5086ef83d6029bba7abf48274772053663e89236c5a31d53d"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368689ed94ab29dd4bc4d492844114acba059d42d1f73716a15987d6309c2720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368689ed94ab29dd4bc4d492844114acba059d42d1f73716a15987d6309c2720"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "368689ed94ab29dd4bc4d492844114acba059d42d1f73716a15987d6309c2720"
    sha256 cellar: :any_skip_relocation, sonoma:        "b07731492916aa2c5b2f41929f670509287e029e8815ca6f0c0e58467d05eba1"
    sha256 cellar: :any_skip_relocation, ventura:       "b07731492916aa2c5b2f41929f670509287e029e8815ca6f0c0e58467d05eba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59fd47cf44cb67fb7ed690baf0f53504d1238c4bc6f742e985284ccbd1b1330b"
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