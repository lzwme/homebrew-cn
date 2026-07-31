class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "25a8639fde44be4366722346d5af70f87e5f85a275b008b6085683a368d2c52d"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae5dfdaeee11b03c583aa3778ad0f8cb2511757b50ac91662a32610924a6b5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae5dfdaeee11b03c583aa3778ad0f8cb2511757b50ac91662a32610924a6b5f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae5dfdaeee11b03c583aa3778ad0f8cb2511757b50ac91662a32610924a6b5f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b66f0466ebda9ac12dae4c523a5d367edf4460cee4554ef7e47f1addb80dc55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8945cba686aaea921ae05a684b4ce85b8fad3085c274f8fe85653aed594ac343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c2a83f4a4a8d22dde8a0fc7df10d5978108c16e8a805d38c5ffb2a09a057dc2"
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