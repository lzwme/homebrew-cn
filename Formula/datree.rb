class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.8.tar.gz"
  sha256 "c1b761395109d0c1ca4cd2f56dda7615fd31e7ded772c160e553f088a13b90a8"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7cd05c581cc062ee26cef4c7418dfd26f2bdc85f2f09dc609bcd7bcaa0cfe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1b85cd2b29fdc33c19b3b2cd44fa00b47861107e07df073b64d0d8a6e2ea5ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d194cc9dc3cf11fbcea1d625143c5ca0d58c362733a34e677779fdf8525296"
    sha256 cellar: :any_skip_relocation, ventura:        "f443d42c683d99606de1ed1b0b617959920d0de499cc6b0c634c524869456397"
    sha256 cellar: :any_skip_relocation, monterey:       "9a32ece9ab84edc6758bd7ececc5b71f6cad5a67285c1efaf211b869c28bb69b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d6419ce2e3438e2f8a02bb66309f357b8154b6985a59e703c8aa179f31edcd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d3d39abbf7835d61c208ad1e5d674492939908d0dd49de1ebdc6261d0419cd"
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