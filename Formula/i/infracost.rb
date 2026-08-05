class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "272c68167e67728dca07dd7e14bc5c06824f3bd47caed854138a0a72fe7fca32"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7769dc79e0efc44a7f49477d71143bf4027b210d99761b0c057e3276d29f7eb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7769dc79e0efc44a7f49477d71143bf4027b210d99761b0c057e3276d29f7eb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7769dc79e0efc44a7f49477d71143bf4027b210d99761b0c057e3276d29f7eb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7be295793d590d9995ad310a50e3c7ef8e31a91473d98f2ccd61e98a4e981d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024cbb0064364d6f25d392e011d4cc94078cfce6e067fce3dfa1d15c03fd0a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42d5158193bbbe1c8d6b804cebb7fb682cf001027324d0e00aa2a72f3724559f"
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