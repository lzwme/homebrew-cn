class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.3.tar.gz"
  sha256 "914bccb47b350e8a07cdf9f6b6863bad7750ddee64b9ce35d9376b101e23f7b5"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "609be6782aa79d8f3e2b1b32fd38fda8d62b0df5cd3d68f0cd9a6b4af31d92cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f0b8f3c95fbad3faa9a7259a24f93ecafa869abe34eb9763f53e88571539a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9530c513c7b96a1815689eff24ae92127b201b203cf84a97e64bc0e2e967d23c"
    sha256 cellar: :any_skip_relocation, ventura:        "240d613ddd9ab8c2719b61eabf311f59456eacf3ac9ba396905c8f0a213558e2"
    sha256 cellar: :any_skip_relocation, monterey:       "17c96f6e6d5acdf44a1d5f3dd010ba8c34d14a6d019813a051f5b7b559d8ddcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b6ac959de76b7176066cb9a22ebc29c274fa2386895aef5254d7021b269cb32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693940cf385ee5378f1ff93ac2bf0473319b70f34e75219a13a48c49ada0cb81"
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