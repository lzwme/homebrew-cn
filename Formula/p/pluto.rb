class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.23.0.tar.gz"
  sha256 "050bc9b47f9ccec6369191606893563748429790f805743a05444897f4a1345d"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd7d57e6c06b304af0943fd4ee03779c084f6daa71b9db9156f7388442d64d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd7d57e6c06b304af0943fd4ee03779c084f6daa71b9db9156f7388442d64d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd7d57e6c06b304af0943fd4ee03779c084f6daa71b9db9156f7388442d64d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "540412e2ccb0139b02427e7a4c8f7cf3df17eae99a5d850427d62639f1a2957e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2036388df7f303103de92933d833344a4e8a5d2282b1bf58efcec681cd535ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3cdce4c876a8587a925be1c47732091a56ef6f4eb449d5cb1d17c00fe80c231"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmd/pluto/main.go"

    generate_completions_from_executable(bin/"pluto", shell_parameter_format: :cobra)
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