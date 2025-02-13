class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.17.0.tar.gz"
  sha256 "820e9edcd29baa13f972c73ca1293556ead0abae20c8578565cbc7be292d8f53"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4895678bc9ae55392003ea46e476e94ffe3ac1d917651fe9f846040e3b20dcdd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4895678bc9ae55392003ea46e476e94ffe3ac1d917651fe9f846040e3b20dcdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4895678bc9ae55392003ea46e476e94ffe3ac1d917651fe9f846040e3b20dcdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "6749805a6600dcdcb76c9366efa38f8e9ae7e95282774e4d6db1bd6863319869"
    sha256 cellar: :any_skip_relocation, ventura:       "6749805a6600dcdcb76c9366efa38f8e9ae7e95282774e4d6db1bd6863319869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab82a7f00c700a88fad737e6ce60398b15b032e171880740d9a2e702477fe2ac"
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