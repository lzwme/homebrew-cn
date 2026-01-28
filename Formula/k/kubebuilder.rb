class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      tag:      "v4.11.1",
      revision: "4fbe8f6c63c6eb9a2a5cc440acbedad6b60d3225"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kubebuilder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "609b8d60a5520ac5613682b19aaa68f28e294b8d5ec978b8cf9b17d02f3f2b02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "609b8d60a5520ac5613682b19aaa68f28e294b8d5ec978b8cf9b17d02f3f2b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "609b8d60a5520ac5613682b19aaa68f28e294b8d5ec978b8cf9b17d02f3f2b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d40029764a0669e92eb886a05ea807aca4621a2f92dcba30d2992353d14ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b42a5dd3bd5730f4bb67ac78fe8abf619cac75430a128ca632b7c42aa74b431e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "661b80aa1b46c34d4d6dcd364dda03c617b1d151aca644dc6d9770f9cfaef6ab"
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

    generate_completions_from_executable(bin/"kubebuilder", shell_parameter_format: :cobra)
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