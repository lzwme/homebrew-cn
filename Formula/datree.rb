class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.8.47.tar.gz"
  sha256 "d145608858a1e06cd483e746b262bb55767bf6f69f8669b83d0298671a03bcca"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3529451e03491cc6166faa980c278fec17fed6a48a10cf5054b998241f50ba7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eded35f369d0aa1e8ab7dad5168758beeca5082aae0016d5aebcbeaab22eaa93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66d02623817475420d1d98199a68acb2973fdd2edd09fdf6141e454e60bb9e1b"
    sha256 cellar: :any_skip_relocation, ventura:        "9e63732a8dc73dbee6b0e88ff2636b25590565d9b0bf046dc4dcc779282b9554"
    sha256 cellar: :any_skip_relocation, monterey:       "fe2ec0a2520ce705b34526e209fcaf2d8e66b0868c6be8b743a5a6c16bf8c09d"
    sha256 cellar: :any_skip_relocation, big_sur:        "33a4cd16add085e84d505fe7ae63590bb9f4c5ffc7a59210c87c2167b3ba2caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a373dcd8f71cbefe88f7376687c8b01e55562b90fae0cd63718b0236febae777"
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