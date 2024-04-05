class Kustomize < Formula
  desc "Template-free customization of Kubernetes YAML manifests"
  homepage "https:github.comkubernetes-sigskustomize"
  url "https:github.comkubernetes-sigskustomize.git",
      tag:      "kustomizev5.4.1",
      revision: "536c1c0a8b66484af18c99b4d371665565f44d19"
  license "Apache-2.0"
  head "https:github.comkubernetes-sigskustomize.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^kustomizev?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "652879953496fac4c135191b94e5dae5bcbffd88fcd61901785f2b7ec702295e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "90222aa38bc81c54e4282c440a522a3207206f75df04efb30ea196a5c0f907ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7b65d8f5b7be0bd60cba0fa8dce52f0f15f75f0d16a66a06917bb302de9ca95"
    sha256 cellar: :any_skip_relocation, sonoma:         "14bc86fbb4538c6eca77c98c301b8eeacc13b1de72a1ab2d8cbd3f705805363b"
    sha256 cellar: :any_skip_relocation, ventura:        "b434e99b6cc2552d1292689501aa8ba15f0911e020bb65cef8c930c85e03ee15"
    sha256 cellar: :any_skip_relocation, monterey:       "e60675b52c947ed499f6de4c2a67be82f3fed62cb9aa6b2185669f2e2bc37e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8309251bc9b8b77c79f896d2e155544a4ac2902b10e5532fc5a7f1b2424558"
  end

  depends_on "go" => :build

  def install
    cd "kustomize" do
      ldflags = %W[
        -s -w
        -X sigs.k8s.iokustomizeapiprovenance.version=#{name}v#{version}
        -X sigs.k8s.iokustomizeapiprovenance.buildDate=#{time.iso8601}
      ]

      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"kustomize", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}kustomize version")

    (testpath"kustomization.yaml").write <<~EOS
      resources:
      - service.yaml
      patches:
      - path: patch.yaml
    EOS
    (testpath"patch.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        selector:
          app: foo
    EOS
    (testpath"service.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS
    output = shell_output("#{bin}kustomize build #{testpath}")
    assert_match(type:\s+"?LoadBalancer"?, output)
  end
end