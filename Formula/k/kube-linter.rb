class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https:github.comstackroxkube-linter"
  url "https:github.comstackroxkube-linterarchiverefstagsv0.7.3.tar.gz"
  sha256 "eca8fa2358d18f087c9f7e0c04e75b199531d4337787f2d05c786190b38ee64b"
  license "Apache-2.0"
  head "https:github.comstackroxkube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14e3309afbcabd3cea1a1f8eb541292784173dff18aee0b758d16aec498ab085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e3309afbcabd3cea1a1f8eb541292784173dff18aee0b758d16aec498ab085"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "14e3309afbcabd3cea1a1f8eb541292784173dff18aee0b758d16aec498ab085"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a7fbdb017896891046e788bef36f69ece12459decb7747bb58d068e24d0fc8a"
    sha256 cellar: :any_skip_relocation, ventura:       "9a7fbdb017896891046e788bef36f69ece12459decb7747bb58d068e24d0fc8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8089c6cd97631953c26089b23c8086054b8deac772e36dfc5fb742bc5cae1245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e382897dad9de7763e1b4b2631f38f3b0669f3beb9e97904f917a23138ac8571"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.iokube-linterinternalversion.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdkube-linter"

    generate_completions_from_executable(bin"kube-linter", "completion")
  end

  test do
    (testpath"pod.yaml").write <<~YAML
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox:stable
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    YAML

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}kube-linter version").chomp
  end
end