class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.21.0.tar.gz"
  sha256 "66ba246cf702629157c0199e4adc1bf4285a3d323a794215c9e86496fd1132dc"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a38330986b15a227cc6bddb0da656449f1364abcf2b6be67d606612c94f81c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a38330986b15a227cc6bddb0da656449f1364abcf2b6be67d606612c94f81c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a38330986b15a227cc6bddb0da656449f1364abcf2b6be67d606612c94f81c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a18f239f4a2fe09259505b96572f73b370956626d9ce73c5dfcf8a034fcc0a5e"
    sha256 cellar: :any_skip_relocation, ventura:       "a18f239f4a2fe09259505b96572f73b370956626d9ce73c5dfcf8a034fcc0a5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f01397a7c46ad79968459fd125f46f9e44c7480ee98c5341b9ed24bb2a096196"
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