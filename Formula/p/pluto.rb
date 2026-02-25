class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.8.tar.gz"
  sha256 "d113fa5fce6b472a486526503d7e9e967481f8f03e1a048aad706089f4621836"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d81142ce5487dda6568a7088702e7e2e9335be7dbbe8fdc354a624bed02f418"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d81142ce5487dda6568a7088702e7e2e9335be7dbbe8fdc354a624bed02f418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d81142ce5487dda6568a7088702e7e2e9335be7dbbe8fdc354a624bed02f418"
    sha256 cellar: :any_skip_relocation, sonoma:        "743e2a4ef2bb4b6d7a36c39edc826ed7aca1b843e02e33dbbc94a5b6a6ccf37d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66791b53c0fa9648b3cc98429446de111c22e2506bcce3e5dd3f002f8fa2f903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b023cd2cb3e6f0de374acb8717af424302521522c0e19a4c36dd0ad3cc5423"
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