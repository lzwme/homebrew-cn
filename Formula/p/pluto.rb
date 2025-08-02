class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.2.tar.gz"
  sha256 "a302bcf8f23dc3c9a2e1b592ad19e1f5750e533ba6f5d1e279ccb3e169cd5099"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e9d3a3c13700d2802b3e3cab48d3b3605cb3c1d7a8c3752726f51f9bf071d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e9d3a3c13700d2802b3e3cab48d3b3605cb3c1d7a8c3752726f51f9bf071d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14e9d3a3c13700d2802b3e3cab48d3b3605cb3c1d7a8c3752726f51f9bf071d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "28f6b0b62553fe8d4673226258e6c771245f5f46463d2be956bbf56dfab4cec9"
    sha256 cellar: :any_skip_relocation, ventura:       "28f6b0b62553fe8d4673226258e6c771245f5f46463d2be956bbf56dfab4cec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c194d684f9041f4ecf0d56752b2e658845d26ece646e036633d6403a688bf2fc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"
    generate_completions_from_executable(bin/"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pluto version")
    assert_match "Deployment", shell_output("#{bin}/pluto list-versions")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: extensions/v1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}/pluto detect deployment.yaml", 3)
  end
end