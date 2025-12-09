class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://ghfast.top/https://github.com/FairwindsOps/polaris/archive/refs/tags/10.1.3.tar.gz"
  sha256 "eaa15224739aea756f67ae84a2e086ec1f6716539245ed37572c064d3d598f46"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd7bd03e67b6dfebf14fd04353910ff437789b085b543a452895c4e6c239831d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d66210fc9a2c1f8734b3f726e6fc590eb2ee073340d579e07a98949ce2e622df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "397d4edde9178e7a6ba027880efe4621ce11ae84ef3e78ef25e31471bfa9b85a"
    sha256 cellar: :any_skip_relocation, sonoma:        "25919769685ca991f65992b8020fee7dad9243ccd2e82ed6c639c45a6b74ba48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677e1b0140ab2c10d144719bb13b88fd5a38ded134ee21d27f5acbfa1ade53ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6741fae123a99f1c79fe28ab58aae29bd4a418f522f2ea8fb6e830638a92ab2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version} -X main.Commit=#{tap.user}")

    generate_completions_from_executable(bin/"polaris", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/polaris version")

    (testpath/"deployment.yaml").write <<~YAML
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: nginx
      spec:
        replicas: 1
        selector:
          matchLabels:
            app: nginx
        template:
          metadata:
            labels:
              app: nginx
          spec:
            containers:
            - name: nginx
              image: nginx:1.14.2
              resources: {}
    YAML

    output = shell_output("#{bin}/polaris audit --format=json #{testpath}/deployment.yaml 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end