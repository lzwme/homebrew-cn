class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.17.tar.gz"
  sha256 "14451e9c23ecb714d46ce6c88ac3b1906f7a38424d60ed935fa836d799406bc8"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e90b70cf9d2bfdd2fb9765006f3ee137eb199738ebc0b70ef84c781ffc0e4c00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e813572bb74c8815b7eefe1261970b51e75099ba5e52331a80c1617170ecbf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5fecdbaa2d1f67959e9d13089962ca6ca0b3c343f20fc7e6ab0326cfcb1ec4a"
    sha256 cellar: :any_skip_relocation, ventura:        "4fb28b4736c89ff0ec77a0dfafc62e346ec9b70ec05f0592e9f60ea069ebd4fd"
    sha256 cellar: :any_skip_relocation, monterey:       "79ab1cf4881ba631d7d6b8dfdca255f3a7261977e8d79d4ddbb4a16175b6429d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c960dcd63e0263b537bd4a2f1b1e7beb28888c2d0ce3b34e55748f1b71dc7ae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54e35b22056354691365c56ad9728c710ea2972dca2a35cb14e65a533a1a8f55"
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