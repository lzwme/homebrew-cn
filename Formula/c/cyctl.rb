class Cyctl < Formula
  desc "Customizable UI for Kubernetes workloads"
  homepage "https:cyclops-ui.com"
  url "https:github.comcyclops-uicyclopsarchiverefstagsv0.20.2.tar.gz"
  sha256 "a412f9f26962893ab3bb662295d94471ff9b9261f3d6cf51e516c360b222e5ab"
  license "Apache-2.0"
  head "https:github.comcyclops-uicyclops.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5eab09b85a74c8abb5c3073541131aee95f4bab332a167f670b01d0a90c18a2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eab09b85a74c8abb5c3073541131aee95f4bab332a167f670b01d0a90c18a2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5eab09b85a74c8abb5c3073541131aee95f4bab332a167f670b01d0a90c18a2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0da2dff93f4baea7c843ba082d7aebc11ca3c5ca5f79b2584e20512469cd6b29"
    sha256 cellar: :any_skip_relocation, ventura:       "0da2dff93f4baea7c843ba082d7aebc11ca3c5ca5f79b2584e20512469cd6b29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d218b2d51e02dbff2e2500d84c26a192b682f03906977d02ce2dc177fdafe349"
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