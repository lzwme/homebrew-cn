class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.8.63.tar.gz"
  sha256 "e2b0301f661efa8af1c171c4a0b1af02b3ab927c66ef487d50b3739c6f7197fe"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94eebb8c5df8242b1bcd5a249d1c5bb01aba062c2af4df68eda946d8fe251263"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0469d18ab51168d3279cffc1349d9d3761b1b33171ad81ac821738db5036630"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79105efd868597779070a0c5474e6ae7556153c0171ff0f2671cae4836d0e834"
    sha256 cellar: :any_skip_relocation, ventura:        "34379b631ab048a74120d56912990b5cea1603c6a157d04c5f0f14afd6fcef47"
    sha256 cellar: :any_skip_relocation, monterey:       "65d219283f91edc668ec10b3354c735100350d2be714753609b83b7987738c8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfde32035da6bf2ce38a43707cb56be975bdbe4d0a84b6af7b6d50affe533f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8b1be1e818ff438ae467149d248b9d54dd8f0caa03a698d61798b43965c071d"
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