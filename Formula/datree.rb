class Datree < Formula
  desc "CLI tool to run policies against Kubernetes manifests YAML files or Helm charts"
  homepage "https://datree.io/"
  url "https://ghproxy.com/https://github.com/datreeio/datree/archive/1.9.6.tar.gz"
  sha256 "6b22f1892ca251e7bc2c5d3061e78e1ab4260222980df2ecc1d89e7aebacdf55"
  license "Apache-2.0"
  head "https://github.com/datreeio/datree.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "037a1b0d1ce3d281ce43da35fb4b47d9085dc37bcbff1f99a2b25fac10c3a84a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e0007345422f764ece5c0c76fd75be3170c904354f3e6efd8cf18aebd4d00fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abf8d9e5b4288edfe15e8d69f78e678e4c6f4f8a3f6e85378809cf3d51a4259a"
    sha256 cellar: :any_skip_relocation, ventura:        "0cd527172e740d27cdc7fe0d2369db975bc468be93395125978c1a722d9f1984"
    sha256 cellar: :any_skip_relocation, monterey:       "4d2569753d49434b0b891d1d40777aab9a790a707c7b2ef6ccc63d87575f8da6"
    sha256 cellar: :any_skip_relocation, big_sur:        "80ef64769a192df258805c81c4f709c29832e12175429b0ff7e75171c1d99e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecaec1c8d6859af01f589e9743fc66d107da489749ed3857d7f8422dd1106454"
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