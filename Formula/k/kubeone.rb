class Kubeone < Formula
  desc "Automate cluster operations on all your environments"
  homepage "https://kubeone.io"
  url "https://ghfast.top/https://github.com/kubermatic/kubeone/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "81bd9a5c25e19b8bada77a64baaa61077ea563f910385e3d3be2ecf2b8a115d1"
  license "Apache-2.0"
  head "https://github.com/kubermatic/kubeone.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86a623a98fb6291e42fb6017d6ec3a47eabcdfc3dac5edfdeaac129f888a98cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da05cecb8a9d4a2c32e48e3a5b61a455fd01d678407a4abe333ed047f7555f5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62a362f92f36dff54f847f6632ed96eacd1a8ce29792b3d95fcf959846c3665b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a120b07a4edb0d96756d83c5d3ee66004422d5cc55016c9df973c20bf16918f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "967ddf9cba182ab9daf552f5e5a6d44e111562c54b90e101ec53584b3579ef2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3546931f670cf5a7961ab4a53d07ebb315ce2bdd830d6e94738bde0dc479461c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X k8c.io/kubeone/pkg/cmd.version=#{version}
      -X k8c.io/kubeone/pkg/cmd.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubeone", "completion")
  end

  test do
    test_config = testpath/"kubeone.yaml"

    test_config.write <<~YAML
      apiVersion: kubeone.k8c.io/v1beta2
      kind: KubeOneCluster

      versions:
        kubernetes: 1.30.1
    YAML

    assert_match "apiEndpoint.port must be greater than 0", shell_output("#{bin}/kubeone status 2>&1", 15)

    assert_match version.to_s, shell_output("#{bin}/kubeone version")
  end
end