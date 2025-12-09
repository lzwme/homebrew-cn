class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.7.tar.gz"
  sha256 "43f1fc3b93238e20c8adbbc133c4cfcb36c6b7ec8430ea22b24119468eddc09b"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8d25c2089f548dc29d0119087240591758964d155e47261f784996365a38a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8d25c2089f548dc29d0119087240591758964d155e47261f784996365a38a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8d25c2089f548dc29d0119087240591758964d155e47261f784996365a38a19"
    sha256 cellar: :any_skip_relocation, sonoma:        "3afda9efb98f89b31aedee1f6c62a774e07871a67e24e43da924db881dcbb6fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a7b01589ff3931c6a400d8e0c12ca855e7f734c4994b0d1f7340b1b307b5104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b57d50df787a2cc4d8de497dd51392714af528857e47851bc23168377a4a21f"
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