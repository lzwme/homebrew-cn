class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.18.1.tar.gz"
  sha256 "80b158306e2f1ee8e31fba18f1feddf6f24796fc775c451482e039561ac96bf4"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "144ae5b7fc8944c1939b6582db7ad26f0459ce767f861cf0af40c2dffac598b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "144ae5b7fc8944c1939b6582db7ad26f0459ce767f861cf0af40c2dffac598b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "144ae5b7fc8944c1939b6582db7ad26f0459ce767f861cf0af40c2dffac598b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "177270fc4276e2c73513191dbf51afd63848ec8c97263acf47e000a11a331882"
    sha256 cellar: :any_skip_relocation, ventura:       "177270fc4276e2c73513191dbf51afd63848ec8c97263acf47e000a11a331882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb863aa4609e00c735786834f2320b77f4bcdaa5432bb508be15275e32fd2b5c"
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