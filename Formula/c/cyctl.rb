class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.11.0.tar.gz"
  sha256 "0173bf858bde69b76dfaa264e3448c54250d541426234e860aee201fe933969b"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "817373a7c8c7700fdeb7d5705eace1ba5b3ecb1d59687547df46c4f079f1117b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "817373a7c8c7700fdeb7d5705eace1ba5b3ecb1d59687547df46c4f079f1117b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "817373a7c8c7700fdeb7d5705eace1ba5b3ecb1d59687547df46c4f079f1117b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "817373a7c8c7700fdeb7d5705eace1ba5b3ecb1d59687547df46c4f079f1117b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d2e269b85fbc00b64444bd4961e7b0bbff19061b060c073bcf299106167faebd"
    sha256 cellar: :any_skip_relocation, ventura:        "d2e269b85fbc00b64444bd4961e7b0bbff19061b060c073bcf299106167faebd"
    sha256 cellar: :any_skip_relocation, monterey:       "d2e269b85fbc00b64444bd4961e7b0bbff19061b060c073bcf299106167faebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c142dcac195c87dda0e4a2b878525916e4109e3f5537698128e21fdbbc0cb57"
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