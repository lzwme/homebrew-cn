class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://ghfast.top/https://github.com/stackrox/kube-linter/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "412a2951851c8a3f279fb99b7d1aebd0b3a6483d1d4a6a2194e24d4859b93c6b"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c6429c5315d4b5a0bef1d989edebc2d96ab91508c9142f9aabc92ab82d46523"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c6429c5315d4b5a0bef1d989edebc2d96ab91508c9142f9aabc92ab82d46523"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c6429c5315d4b5a0bef1d989edebc2d96ab91508c9142f9aabc92ab82d46523"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a7b8243658b8eb9346921dc65f87d80b22d01c8b56aa1cf872b29f411fbbb5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f2aac26be0042bab65336eaf6068601fdb2b3d43cf6a4396418c02c8515e875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41267624d034c2d2e5b31012512177f6763f5688ab42f6b8d1a50480911ebcef"
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