class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.8.37.tar.gz"
  sha256 "a1458dc10bff2231fe74be5f335d7852bcd0547487a0be43ebdea19c6ddd9058"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9510cd340a170ca5fb504fbd628524c7104be533125055b5830bacb0097b209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9275c9273fff8af5dcd1514690323a3ecf087cecaab0f8c6ebf7927f94ce0ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff2c6f2c4328523ff6fffc49ff0aec2030bdfb4eb089cd499d68fe5f92cd1c3b"
    sha256 cellar: :any_skip_relocation, ventura:        "ba099ceafa8e4218a16908a092ad397062e25ffa99beea699990702148ac2231"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f0c51de598a834af4995f5b3b8a01c7b9a0a3e8db05fef2ea1faff0a8811ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0a5b12ecd8a41967c359d6a89febc6d13577cdbbaa10070ae50fa4e9a8ab720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8be125469430771d7aba23cc4cdfba44babedb35ebadf8dbdfe11db20eef95"
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