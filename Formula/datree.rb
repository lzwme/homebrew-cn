class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.2.tar.gz"
  sha256 "a9552a571e4f93e2c9e4fa9460578734e578412bbe6470c53eaee1182309ef48"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b98ec2f06f4db7885ea43335e6b307ce5f30e164bb26310b0d91f752614dd1d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e54b8dfab57718b5c466053939b894cfeab14f4bedb8d4d53efc84daf437fb7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cbc0076c2a92bb90a095d5512d8cf4f03257c874e00fe2e6d68ea7d187fa000"
    sha256 cellar: :any_skip_relocation, ventura:        "4742475a1cfce78cbf8995e27a58b60ecd0b09302b9dcc1f34700874c83ef5af"
    sha256 cellar: :any_skip_relocation, monterey:       "43e95e1f70ce0c3891af414d43a169c7b51ec9a061b0301942f226fddb0d8a0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "613eda71abb2ab9d91b26e4596dc0a207e37c6c0c5a81a7c5f26304715fb8f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c76e2ef1ba8d881074565bf6d8f323c2adf3aaf8409185820e644525bd50fa"
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