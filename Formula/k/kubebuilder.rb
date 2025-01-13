class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v4.4.0",
      revision: "55097d022e2f99ec9df942ab1bee122369612571"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d317e2b232ae4f5c9d1868839d6a6de09e6eaad8274573d9d3915cb5129cdb8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d317e2b232ae4f5c9d1868839d6a6de09e6eaad8274573d9d3915cb5129cdb8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d317e2b232ae4f5c9d1868839d6a6de09e6eaad8274573d9d3915cb5129cdb8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b4fccc5728868c83694b60b1483c1de3a439e7a92ee85124a1c45c04e175941"
    sha256 cellar: :any_skip_relocation, ventura:       "3b4fccc5728868c83694b60b1483c1de3a439e7a92ee85124a1c45c04e175941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "142624d013459b576a03a7f3987580b87dabf40d78a09a5ba271eb4e22f09637"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X main.kubeBuilderVersion=#{version}
      -X main.goos=#{goos}
      -X main.goarch=#{goarch}
      -X main.gitCommit=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmd"

    generate_completions_from_executable(bin"kubebuilder", "completion")
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.iov4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~YAML, (testpath"testPROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.iov4
      projectName: test
      repo: example.com
      version: "3"
    YAML

    assert_match version.to_s, shell_output("#{bin}kubebuilder version")
  end
end