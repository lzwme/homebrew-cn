class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.8.46.tar.gz"
  sha256 "cfa6470402d506af467aeb98ea350a3d9c31c513f030fe26a9acd6e641aa9456"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc54b709bb37f8a40503fba8036ce34bb5f3aea2f3aebe4fe009a855bf12a3b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c100278ecbd24993f1c0c7ae2e58d4c266e11e2c465b8da67679a37109b5130"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aac7540e4300a32df5c188dc818dabb102d412f646d6e2dd7bc867d45d73fac"
    sha256 cellar: :any_skip_relocation, ventura:        "37a4f864c40e017c1cadb0a1455b6ca255d7115553fd1b44fcf1f963d4396b86"
    sha256 cellar: :any_skip_relocation, monterey:       "984d4651ebe2b8925f1fee7cf057148ecd53eec5249d3ccbdf80c137345a957d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6c95f177bc3eb6fc77d62309119f0e8b472ba0ae31ccd60511338742887f0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "889d01392592347292f63b9149f9ab52e462db52cd24380d86afd1a891341c6a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/datreeio/datree/cmd.CliVersion=#{version}"), "-tags", "main"

    generate_completions_from_executable(bin/"datree", "completion")
  end

  test do
    (testpath/"invalidK8sSchema.yaml").write <<~EOS
      apiversion: v1
      kind: Service
      metadata:
        name: my-service
      spec:
        selector:
          app: MyApp
        ports:
          - protocol: TCP
            port: 80
            targetPort: 9376
    EOS

    assert_match "k8s schema validation error: For field (root): Additional property apiversion is not allowed",
      shell_output("#{bin}/datree test #{testpath}/invalidK8sSchema.yaml --no-record 2>&1", 2)

    assert_match "#{version}\n", shell_output("#{bin}/datree version")
  end
end