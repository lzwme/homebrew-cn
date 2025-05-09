class Pluto < Formula
  desc "CLI tool to help discover deprecated apiVersions in Kubernetes"
  homepage "https:fairwinds.com"
  url "https:github.comFairwindsOpsplutoarchiverefstagsv5.21.6.tar.gz"
  sha256 "a924d9e37b5d60564d06b7bf11feb78e9fec4a6c4261681583f1a8c42613598d"
  license "Apache-2.0"
  head "https:github.comFairwindsOpspluto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e67107a7d805fa5b9d3634e575a349b2e9b8354339b596a1534ecea846032e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e67107a7d805fa5b9d3634e575a349b2e9b8354339b596a1534ecea846032e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e67107a7d805fa5b9d3634e575a349b2e9b8354339b596a1534ecea846032e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "86c69bdcf5d472f64e30949ce06b6fe313216a9eb0323aeb62a922e04f16befa"
    sha256 cellar: :any_skip_relocation, ventura:       "86c69bdcf5d472f64e30949ce06b6fe313216a9eb0323aeb62a922e04f16befa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5c27f26c7ed7515650b3f0bc058fad12e916abe60eeaceccc84b7261019e0ae"
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