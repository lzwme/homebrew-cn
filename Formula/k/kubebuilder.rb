class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https:github.comkubernetes-sigskubebuilder"
  url "https:github.comkubernetes-sigskubebuilder.git",
      tag:      "v4.5.1",
      revision: "0ace7a8753c52b35014e43edc2a0b0454b78e769"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd51f5da30d6a61d5db0500aa17f98cc9f2ed39cafdf94fc245b832c053fea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd51f5da30d6a61d5db0500aa17f98cc9f2ed39cafdf94fc245b832c053fea4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "edd51f5da30d6a61d5db0500aa17f98cc9f2ed39cafdf94fc245b832c053fea4"
    sha256 cellar: :any_skip_relocation, sonoma:        "38752d6cc402fbdc83f2c1ac3aabce5c6020288075b0d581e748028902d02538"
    sha256 cellar: :any_skip_relocation, ventura:       "38752d6cc402fbdc83f2c1ac3aabce5c6020288075b0d581e748028902d02538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6600c6765c094c6c8660d85cad3e62ac2249b3a8a23e271e9c5ad2badbff86bf"
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