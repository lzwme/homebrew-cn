class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://ghfast.top/https://github.com/stackrox/kube-linter/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "a6622df542b4eff596cd8bb06a317823bb1837ddb19d9f8945df85e337354a72"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0968e84b1374de5d5faa476532357afb5d71de0a895fe840bd87762c987f4d1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0968e84b1374de5d5faa476532357afb5d71de0a895fe840bd87762c987f4d1d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0968e84b1374de5d5faa476532357afb5d71de0a895fe840bd87762c987f4d1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa6b59b308d2163c4472619f8937df2e20ad418cf1d76047abcd6553bde449c4"
    sha256 cellar: :any_skip_relocation, ventura:       "fa6b59b308d2163c4472619f8937df2e20ad418cf1d76047abcd6553bde449c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dfb83243350eca96a11aaffef522c6fdafebb9f897f329730f5f90f9528cc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10e547efaf3430c45e516e8a81c69718627bf6f2627fe9d42fce7cd909c8b038"
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