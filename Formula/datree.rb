class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.8.64.tar.gz"
  sha256 "8a14465ce5c43ddb7e2b976659b4c88f638788d296fd88e9118677028a1990e2"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63f300499904ab14971d6d7f75f477739cead06cd262432c5d2d72c9a17c4d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c03d3be006b5358afc7af4e27abd8330c900623862dcd7f455f15a034949a11b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e149602820d70d507bd543218c97c4cde1b53a76a77d4c88ea32e0050a6dcce4"
    sha256 cellar: :any_skip_relocation, ventura:        "929ebe4f6ad6204454fd94fc06fd45b8b8ce97ec0dfa18c49058ffe77bcf2b80"
    sha256 cellar: :any_skip_relocation, monterey:       "37269b6724114a4d1babf30e31b72a5993c9b42b381a4efa7441dc8c50756c33"
    sha256 cellar: :any_skip_relocation, big_sur:        "e09357fc8af53217b18a9967e3f91515918e18f01908a93b893b5886f4f01f9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10f51d9128f5c1b6a3d3b376754619b04aaf6e29696aeaae21f018c9a2443a32"
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