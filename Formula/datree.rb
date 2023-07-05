class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.10.tar.gz"
  sha256 "482b82e32165d63b59da274cad456848dace2efc3e9a0648446831f3c1624c4a"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7521afecfbe22a4d5ebc35bd66aecdad3c3b2a3de9a62412635e8f2c0ff12438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae7377fecfab910f6b8699cb1f3f28ec2919d7bd17b4160abbc288104f4c1418"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03cd25f9692df206435ae6da743dc2a6b04fdf3f12a7a0d73ad18577f29f36dd"
    sha256 cellar: :any_skip_relocation, ventura:        "b9f1871432fac855d55a86969cc6f83c84fb82bd8f46b2b9b17952ba8922a6cf"
    sha256 cellar: :any_skip_relocation, monterey:       "24ed228f2605dea2c198cd6aafbb697850e3937a62c2562ba8528cf2135ebee4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5fa4e2730c128139854b8863f8c3aa59e3fc25dfc4119f020eb1e383665dd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181fd872baaebe7d47f975931a8df223d38ff091561137f40cbaa8f771b7ddec"
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