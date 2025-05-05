class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.20.0.tar.gz"
  sha256 "84b2a9149966c7795f3685d7ff4e5e6f1f36433fe7f10d0ba5f28d257a1ef9c7"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7cf74c800bb7c02afde79bfa5881bf275a301dbea5258f293c6cf37a38114a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7cf74c800bb7c02afde79bfa5881bf275a301dbea5258f293c6cf37a38114a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7cf74c800bb7c02afde79bfa5881bf275a301dbea5258f293c6cf37a38114a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac684fd8a936d62cf1fb5f88cfa147fb12f29dafedf00579ad1b68a4b54014f8"
    sha256 cellar: :any_skip_relocation, ventura:       "ac684fd8a936d62cf1fb5f88cfa147fb12f29dafedf00579ad1b68a4b54014f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa20b9abfbfe6ede6edce51c3e0a10ac9a994a3c138dd8b0829e6f34ea3107cb"
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