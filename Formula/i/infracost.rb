class Infracost < Formula
  desc "Cost estimates for Terraform, Terragrunt, and CloudFormation"
  homepage "https://www.infracost.io/docs/"
  url "https://ghfast.top/https://github.com/infracost/cli/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "ee542f551648cb2f203e777b34cbe18f426690c06d9127bc268053865bd7c8dc"
  license "Apache-2.0"
  head "https://github.com/infracost/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ad7cf85bf13dfec6e829088293d71a0ff17c737680c303fae31b82ec619951b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad7cf85bf13dfec6e829088293d71a0ff17c737680c303fae31b82ec619951b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ad7cf85bf13dfec6e829088293d71a0ff17c737680c303fae31b82ec619951b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c774651c67c69c426db48dff4da57c1828e5a15db43b63dce14fe4f7b8b26ddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2992880c04e12a312ae4ab11e5dbe4cfa717943560bb652371e02c4270047079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "481d5337d3c4498f4c953d0907fe58ff41496907b5449da7a8319612c846c342"
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