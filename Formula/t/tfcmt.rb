class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.13.tar.gz"
  sha256 "2d8d1ca8e3bbede04b31d2e88aa09e417c127e3ce8ebfdb0252aa3652888a207"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96ad303fa752584132edcb2edeb38be5e2f50b50ffac04757a1e9ef9d9c01e73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96ad303fa752584132edcb2edeb38be5e2f50b50ffac04757a1e9ef9d9c01e73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96ad303fa752584132edcb2edeb38be5e2f50b50ffac04757a1e9ef9d9c01e73"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ac218683bdfe170085c33c169b951050446228f19085086cd464c658384c3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8983ce0969cf8722802bf6be54387cd4a95902972e2ff0f5da2f8777ce2d7f16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b4ca0e17587ba14364bd726dfe70af76bd22ac5699ccee5f88139b0b43e9e3d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfcmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfcmt version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    ENV["TFCMT_GITHUB_TOKEN"] = "test_token"
    ENV["TFCMT_REPO_OWNER"] = "test_owner"
    ENV["TFCMT_REPO_NAME"] = "test_repo"
    ENV["TFCMT_SHA"] = "test_sha"
    ENV["TFCMT_PR_NUMBER"] = "1"
    ENV["TFCMT_CONFIG"] = "test_config"

    output = shell_output("#{bin}/tfcmt plan 2>&1", 1)
    assert_match "config for tfcmt is not found at all", output
  end
end