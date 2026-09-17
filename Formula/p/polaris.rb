class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://ghfast.top/https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.4.tar.gz"
  sha256 "4ba36dd80a9987e4ab7f4b9b6147b29d07f1ec452734184bb0f41352d57a273b"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "80d49f529cb1b20c0bb748846640fc1aa9700998d66b6dfa31a9f43d006a37cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0989cf713fcff89e4e83de84d4ad970b1e2e075bacb64ab413a7a818db490ca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f4c7acbe500d075a1a5f3507011ad01f56827b8935abbc5934ea5c7034e51c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14ccc01ece3434f93058ef0109b21699d0fb7fbcbe0a8776877d13a25434550f"
    sha256 cellar: :any,                 x86_64_linux:      "901c75101de6d365a7ebc266ad0aa9a3644a980c9316840b409ae9e217fb4f06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.Version=#{version} -X main.Commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"polaris", shell_parameter_format: :cobra)
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