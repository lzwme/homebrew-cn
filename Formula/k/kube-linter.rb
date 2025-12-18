class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://ghfast.top/https://github.com/stackrox/kube-linter/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "0d67ce0bf15203abdf6193590b21924a988ed406ea6221bd83a08d67405ffb04"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7830759e1688fa7b45842ede9fef8d2861c6b0d8a87873ef85d4a450cb215234"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7830759e1688fa7b45842ede9fef8d2861c6b0d8a87873ef85d4a450cb215234"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7830759e1688fa7b45842ede9fef8d2861c6b0d8a87873ef85d4a450cb215234"
    sha256 cellar: :any_skip_relocation, sonoma:        "329de0f096b6bbb58674ff7466371fd34c845fd26650cd4589459dc7e992229a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7676a74b2886c13490d233d01ffaa3562206d69b0d0cdf7e13b101fe21f10a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d1ac7d564028714d17f0c6eec4b0b9c7b4f89d522689de1a9114b64e81d1c18"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kube-linter"

    generate_completions_from_executable(bin/"kube-linter", "completion")
  end

  test do
    (testpath/"pod.yaml").write <<~YAML
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
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end