class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https:github.comstackroxkube-linter"
  url "https:github.comstackroxkube-linterarchiverefstagsv0.6.6.tar.gz"
  sha256 "02f49d8f615e8549a8bc690d9aac93fb4fde3deb4d0ad803c654ff19d70736c8"
  license "Apache-2.0"
  head "https:github.comstackroxkube-linter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "186f574bfa0a681e027a50b34d44d9b222a60fbcb2382d719f2524b835d44946"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "186f574bfa0a681e027a50b34d44d9b222a60fbcb2382d719f2524b835d44946"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "186f574bfa0a681e027a50b34d44d9b222a60fbcb2382d719f2524b835d44946"
    sha256 cellar: :any_skip_relocation, sonoma:         "e14b118d4895e248d6914ec62f7e507be427e9f7e90402516e2b5fca820c8c14"
    sha256 cellar: :any_skip_relocation, ventura:        "e14b118d4895e248d6914ec62f7e507be427e9f7e90402516e2b5fca820c8c14"
    sha256 cellar: :any_skip_relocation, monterey:       "e14b118d4895e248d6914ec62f7e507be427e9f7e90402516e2b5fca820c8c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4cd2982307595278def4f5eb18c95c6d987c1e4f662c02e0e9e6f8f74bd8d4"
  end

  depends_on "go" => :build

  # support go1.21 build, upstream pr ref, https:github.comstackroxkube-linterpull696
  patch do
    url "https:github.comstackroxkube-lintercommit1085300cc73a29961547c4507bd4acdb4f385c64.patch?full_index=1"
    sha256 "50ebde54ac0c69fb19ccd2d545c1ec079256bd5c15cdd4d9199bb2007f64a9c0"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.iokube-linterinternalversion.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), ".cmdkube-linter"

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