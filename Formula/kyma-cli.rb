class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/2.14.3.tar.gz"
  sha256 "9bb7910c21076d14ccceeb5175e4a7fc2518ff4f95f18bc28d71caa0bfbc3f97"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74d71455ce3858caeef1a7c8a6a3b9d2025b73f02728ac7696b8bbfc3116807e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fe84a7636d55bad8a219d94f16daa3ad1a00e2a325d79cf2565d86c56c3eaf9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e93554a98aa1ea15aad1e43d4ebda98b50ecda0f44a159ba4f5ee2e38652e79"
    sha256 cellar: :any_skip_relocation, ventura:        "4700d70eac465013fb00367689fa36b76355a97ff184b0304fb28a2cfa966fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "2ccad6a99a8cf88f81c7f218825856dd5fd21e949bf0d19604f5b076ee37d439"
    sha256 cellar: :any_skip_relocation, big_sur:        "859cf68a31545975ade375470705a8aba4621aef0adee0a445b198ddec5ebc66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "062ba100f8e6bcf1d074c0af627f08990cf95a6aa3c69fae292a4623babe5598"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"

    generate_completions_from_executable(bin/"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end