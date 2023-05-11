class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.0.tar.gz"
  sha256 "577278c368cf8cd46c6aa7c35342f7d1155bcc47dc589b8c57811a2034c5dea6"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b4c3bc5d864e2ce5eade4ff6a2cee1371271d513959a607ea4616371eba8e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf30eedafdc7e38ad5bde8f9340fd206e9e5527660e85e55093c18187106eda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c910712e464e1fa89dd46193f8ce40fb239cc62115d4d9331a23d51c41a44010"
    sha256 cellar: :any_skip_relocation, ventura:        "235eb89b483b19e93bcfbd2c19cb5e279504938cd0c3627d015b966a1b2c1de9"
    sha256 cellar: :any_skip_relocation, monterey:       "625639f4837f0e2dcfbab943431e6642ee331240085df7f9f654cd8d6e3c7eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a28fc4d5dc6e768497e446d96d3d1166424b9164c9160bb2a5ae2d67571e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdda2faff9f5018a6a219293e3591a5f01f5d7c1b58e739553a4aa34d5bba568"
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