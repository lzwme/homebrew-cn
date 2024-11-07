class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https:github.comstackroxkube-linter"
  url "https:github.comstackroxkube-linterarchiverefstagsv0.7.0.tar.gz"
  sha256 "134af09f571937376ed3ff7bae07eba52357d20bd067618c00e4fea7baabadd8"
  license "Apache-2.0"
  head "https:github.comstackroxkube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c4bc93759d4052b16bc90691a2d23aa571b021b3dfabaecd989aa12c9cd2595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c4bc93759d4052b16bc90691a2d23aa571b021b3dfabaecd989aa12c9cd2595"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c4bc93759d4052b16bc90691a2d23aa571b021b3dfabaecd989aa12c9cd2595"
    sha256 cellar: :any_skip_relocation, sonoma:        "da8d3380223a5a9efbd36a527fd524db5c3f5923ae03351a2475ccbbe23e551d"
    sha256 cellar: :any_skip_relocation, ventura:       "da8d3380223a5a9efbd36a527fd524db5c3f5923ae03351a2475ccbbe23e551d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69a63411a6670993d4676d9ae0fe31d33c66c98b8e79c788455c86a12ec89862"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.iokube-linterinternalversion.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdkube-linter"

    generate_completions_from_executable(bin"kube-linter", "completion")
  end

  test do
    (testpath"pod.yaml").write <<~EOS
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
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}kube-linter version").chomp
  end
end