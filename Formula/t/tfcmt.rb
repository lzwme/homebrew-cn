class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.9.tar.gz"
  sha256 "b0abe2aafc91e44db8a5c526846ce2c4cd4e9dfe2298cec0fab8fee6e40ba006"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9299f9fc1237fe248de4866779e7b1b915f7177ca328ab66435af2158107909f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9299f9fc1237fe248de4866779e7b1b915f7177ca328ab66435af2158107909f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9299f9fc1237fe248de4866779e7b1b915f7177ca328ab66435af2158107909f"
    sha256 cellar: :any_skip_relocation, sonoma:        "82cdd635d6e41d4572a1d82335ecf936db6fabcf3f0a02eb6be531f35f190fe3"
    sha256 cellar: :any_skip_relocation, ventura:       "82cdd635d6e41d4572a1d82335ecf936db6fabcf3f0a02eb6be531f35f190fe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "161094003a11b82fd79b294775ca4207553b12aa839c469332823f2b3b832259"
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