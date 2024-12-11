class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https:testkube.io"
  url "https:github.comkubeshoptestkubearchiverefstagsv2.1.74.tar.gz"
  sha256 "42c055c60b4eb965bdbb6c2dcc179eda7dc5faee4c15fbe01f4252d16c0f64bb"
  license "MIT"
  head "https:github.comkubeshoptestkube.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c7f03b75226ad9301fcb36d21936f4e5ac165598257e2ec9587254302f5cbce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c7f03b75226ad9301fcb36d21936f4e5ac165598257e2ec9587254302f5cbce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c7f03b75226ad9301fcb36d21936f4e5ac165598257e2ec9587254302f5cbce"
    sha256 cellar: :any_skip_relocation, sonoma:        "640c065a0003b7301be6f445af4f6a3850134e029e539aad85d423278b27b66f"
    sha256 cellar: :any_skip_relocation, ventura:       "640c065a0003b7301be6f445af4f6a3850134e029e539aad85d423278b27b66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "addbfa8705a2d17ab3445f4f9a2715491c76f6d5594b7f1a7d7f3126997a3730"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.builtBy=#{tap.user}"

    system "go", "build", *std_go_args(ldflags:, output: bin"kubectl-testkube"), ".cmdkubectl-testkube"
    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin"kubectl-testkube", "completion", base_name: "kubectl-testkube")
  end

  test do
    output = shell_output("#{bin}kubectl-testkube get tests 2>&1", 1)
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end