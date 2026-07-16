class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "351d29ee956efb06e51c01e146c1f797e33055234466605384b31e6c34d8d3c2"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e53b1e91455a5d91ea9f87ac334c40592a5f287c7a751c6c1e8db3aeeefddba2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e53b1e91455a5d91ea9f87ac334c40592a5f287c7a751c6c1e8db3aeeefddba2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53b1e91455a5d91ea9f87ac334c40592a5f287c7a751c6c1e8db3aeeefddba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f8f8d965a5e155f61bbd91600b8b410a2550ce4a49a4de6ea7c294c44aa5c50"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c755d187fb264015485b6882d0802927e413c68472115951ceb149b50493dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7269af927e54c3628007aacac5b5742bdba3ecc65d76ded3b8cb4eb80ae1bea"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/cli/version.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"infracost", ldflags:), "main.go"

    generate_completions_from_executable(bin/"infracost", "completion")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    ENV["INFRACOST_CLI_AUTHENTICATION_TOKEN"] = "dummy"
    output = shell_output("#{bin}/infracost setup --no-color 2>&1", 1)
    assert_match "setup requires interactive login", output
  end
end