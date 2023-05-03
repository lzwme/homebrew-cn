class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.8.67.tar.gz"
  sha256 "8b99a016bd9fbba8518c7e1aecc9dac4dd9b30217277d3ed7209db8ffba8a5fa"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694eaa5c952db00ddbfd3b02c3733eec43ec61cee07f336e2d51fc44a986334a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a7306625454391a3abca51f98716927ce5dc4bc24273ba9299e268cd26a387d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1092b2400d58eec7f9705c8906945fac03b40928bc307e94dc72aa48cd96b039"
    sha256 cellar: :any_skip_relocation, ventura:        "ba3baf4c8eadff3ed8b6a3a306b7e90fd7d28d737e93445a7fe8768375247de4"
    sha256 cellar: :any_skip_relocation, monterey:       "6c5a15a263fbf1d3681ad327273283fa8aa8f588e751f3d2d269edbfebf2cc6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1a8f4725cda0dc3a6c8dc3b4c338a3d19d652cd8a7159784e5160fd2240b62a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78219384e889714433155cc421b5b2713caec7074abb4ed3f93a7930530f9320"
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