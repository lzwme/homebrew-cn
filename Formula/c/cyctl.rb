class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.18.4.tar.gz"
  sha256 "201aa82e52aba51f527db6abd074bef35b7c26d84f4045edff8e4678fd050b0b"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f054e975336544ee99d97708b1b7a4aa24328e2349c6f78ec7c18199e7649777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f054e975336544ee99d97708b1b7a4aa24328e2349c6f78ec7c18199e7649777"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f054e975336544ee99d97708b1b7a4aa24328e2349c6f78ec7c18199e7649777"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d05acaab9c63d02d07c74787af0ffe2d222a755452b8eb70cf8455917f30d54"
    sha256 cellar: :any_skip_relocation, ventura:       "0d05acaab9c63d02d07c74787af0ffe2d222a755452b8eb70cf8455917f30d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6952a079011d2c423f3d494010e9ab2b47570d0f513f8e4602f6294aed1def91"
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