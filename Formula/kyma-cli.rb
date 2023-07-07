class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://ghproxy.com/https://github.com/kyma-project/cli/archive/2.16.0.tar.gz"
  sha256 "bad2564b86addad90131f045cefdffcb8b9f481d528537d8b9557b82f38bd9cd"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b135eeccb691f9be3f0a97e9e9ec18b4384a07d75e89b029127a84a593560fca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "460c47d1f22d21c9d38a7c67b852319754f46cd285dc27b4371fd423ff6c3a89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7eb5ee38a4e7f2421b8db067353c3bb036c5bcd89ade57ebb0f439b868de9a2"
    sha256 cellar: :any_skip_relocation, ventura:        "c572360cd83058337bfbc5783257f0c7b7684549cfa489e66990a650bf9e14db"
    sha256 cellar: :any_skip_relocation, monterey:       "e2fed53d362f14942737a7dcb30908c24e075b4e1b2051765bc40b0d5d5aebfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e94756bb08f103d581adf9fef3c6a6aef59e5912248f9694779f9394c67c51dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c425e59fa375cbbd464ca20858addabc4c557cdcae9ea2d1d2e13226dcba2810"
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