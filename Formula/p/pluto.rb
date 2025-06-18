class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https:fairwinds.com"
  url "https:github.comFairwindsOpsplutoarchiverefstagsv5.21.8.tar.gz"
  sha256 "c40063cdd8711df13470ba50e2720d3ee8d4b2b7401ad1174356af3952f4b5f4"
  license "Apache-2.0"
  head "https:github.comFairwindsOpspluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0219da1717c3008f009aeed24ab7e189598a8a401576d9448b1c0a98b456c96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0219da1717c3008f009aeed24ab7e189598a8a401576d9448b1c0a98b456c96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0219da1717c3008f009aeed24ab7e189598a8a401576d9448b1c0a98b456c96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ff56427093a1ea4db3842eb7034a5f92c45fbfc62bd760d1c66da3b9326a162"
    sha256 cellar: :any_skip_relocation, ventura:       "6ff56427093a1ea4db3842eb7034a5f92c45fbfc62bd760d1c66da3b9326a162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1752fb8b4f04375fc44489f54aafab40517f454b792e4d7d4b0d211c85905830"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "cmdplutomain.go"
    generate_completions_from_executable(bin"pluto", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pluto version")
    assert_match "Deployment", shell_output("#{bin}pluto list-versions")

    (testpath"deployment.yaml").write <<~YAML
      apiVersion: extensionsv1beta1
      kind: Deployment
      metadata:
        name: homebrew-test
      spec: {}
    YAML
    assert_match "homebrew-test", shell_output("#{bin}pluto detect deployment.yaml", 3)
  end
end