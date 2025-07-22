class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https://fairwinds.com"
  url "https://ghfast.top/https://github.com/FairwindsOps/pluto/archive/refs/tags/v5.22.1.tar.gz"
  sha256 "6c502e160296e35f9aa51cdbc4767718def7b5846b0f648c472dd427f76ce6ab"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/pluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb5632a6a7cbe4cb77af2c411ea05fee10ba7c21156d9fe0371ff76c5150bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdb5632a6a7cbe4cb77af2c411ea05fee10ba7c21156d9fe0371ff76c5150bd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdb5632a6a7cbe4cb77af2c411ea05fee10ba7c21156d9fe0371ff76c5150bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d82a09134958705f25c69b5c5da985074eecb7ab858acbde4b6a8ea00d445f6"
    sha256 cellar: :any_skip_relocation, ventura:       "3d82a09134958705f25c69b5c5da985074eecb7ab858acbde4b6a8ea00d445f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23501eb46e3e496deff0be7b8060fd1109037847595dcec08916c3556c4e9afd"
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