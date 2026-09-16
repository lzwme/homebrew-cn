class Polaris < Formula
  desc "Validation of best practices in your Kubernetes clusters"
  homepage "https://www.fairwinds.com/polaris"
  url "https://ghfast.top/https://github.com/FairwindsOps/polaris/archive/refs/tags/v10.2.3.tar.gz"
  sha256 "7608471f6c4afae8212055e599531bf60cc08ee621605b8cdfa6876e71f8e125"
  license "Apache-2.0"
  head "https://github.com/FairwindsOps/polaris.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a01c826bb64ac0d99fe327cab047d6baf40f887269549145547d60b8b836b0f7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "daee374cc594ca9ca683a0b2d80e71d7fee407b3df0b25b11664695f4714cb5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "82ce6a300399cbbd7551b2eb14959a09ecbf950d6e5da84e1aa10aed4d9e392f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "457eb14c4e33dc5125c6a609a23a56e1be78e335e79c212b77b795648c984112"
    sha256 cellar: :any,                 x86_64_linux:      "b3b7217017a73f96a7927a041405c22fd17f9d66e984ac302e1fce399046798b"
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