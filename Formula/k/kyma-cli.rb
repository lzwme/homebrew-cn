class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/refs/tags/2.19.1.tar.gz"
  sha256 "85dcbf5f4ef1818300187da804a475adb01560fd1600d234d566ad00a3b314e9"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f61d9161b7e3206efe8eb5d28b3eac2f6462a0495a3cfe40e3106150270a7497"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba2f1cf0cee12410442c2723b68d6274cc8c644835566a9512f1ba9074b14f96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0bd8a269b176bbca5ca75d6636c204eaa7facf505c821820ec0fa9ba1cf69c"
    sha256 cellar: :any_skip_relocation, sonoma:         "299b4bf13b1ba38b5370054121b154c5e53208f1ca59bf04d950f7f875fb4044"
    sha256 cellar: :any_skip_relocation, ventura:        "16c0cf74e430944f0732e957448d7ad9df97a60097fac7e9bad70106032443cc"
    sha256 cellar: :any_skip_relocation, monterey:       "446e72fdbd6178914ad470fc1b2ff7535c80b7dd1e1500e9096e4bb99dd3f0cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9ea93424ff24f05bc118cf86b6f7e93cb68be60101570adcd137e81805af50"
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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}/kyma version 2>&1", 2)
  end
end