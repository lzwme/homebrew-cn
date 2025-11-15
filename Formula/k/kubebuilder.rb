class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.10.0",
      revision: "9eee7a747b59a951bde06c84c8684e895966d6d2"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df196bb9f003504224fd8d0aebbc286e8835fba38cf5f711ef1c4b368883072d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df196bb9f003504224fd8d0aebbc286e8835fba38cf5f711ef1c4b368883072d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df196bb9f003504224fd8d0aebbc286e8835fba38cf5f711ef1c4b368883072d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b3efea9b4ee253a821eab901ae9813a5903adc17bbcfa0df4efb3b8d47b03fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5ac44ba749b19d4f7ae82d66c1043a5e302fa4eaa8d9f8de094311a4db36e21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14ca3c7725317a0e23b95d54bc08b5a04a3f5a74839e40cf9108f23c6a1b8cd6"
  end

  depends_on "go"

  def install
    goos = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOOS").chomp
    goarch = Utils.safe_popen_read("#{Formula["go"].bin}/go", "env", "GOARCH").chomp

    ldflags = %W[
      -s -w
      -X sigs.k8s.io/kubebuilder/v4/cmd.kubeBuilderVersion=#{version}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goos=#{goos}
      -X sigs.k8s.io/kubebuilder/v4/cmd.goarch=#{goarch}
      -X sigs.k8s.io/kubebuilder/v4/cmd.gitCommit=#{Utils.git_head}
      -X sigs.k8s.io/kubebuilder/v4/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubebuilder", "completion")
  end

  test do
    mkdir "test" do
      system "go", "mod", "init", "example.com"
      system bin/"kubebuilder", "init",
                 "--plugins", "go.kubebuilder.io/v4",
                 "--project-version", "3",
                 "--skip-go-version-check"
    end

    assert_match <<~YAML, (testpath/"test/PROJECT").read
      domain: my.domain
      layout:
      - go.kubebuilder.io/v4
      projectName: test
      repo: example.com
      version: "3"
    YAML

    assert_match version.to_s, shell_output("#{bin}/kubebuilder version")
  end
end