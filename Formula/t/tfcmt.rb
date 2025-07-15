class Tfcmt < Formula
  desc "Notify the execution result of terraform command"
  homepage "https://suzuki-shunsuke.github.io/tfcmt/"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/tfcmt/archive/refs/tags/v4.14.8.tar.gz"
  sha256 "8952deff8769db9eb8dd6f5e718a8cacdce45c6252013d87a2a17ee956d99e29"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfcmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64c6d34eadd45a50a97cb4072b17f457bb618a578cc4f90f1069a52226b733e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64c6d34eadd45a50a97cb4072b17f457bb618a578cc4f90f1069a52226b733e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64c6d34eadd45a50a97cb4072b17f457bb618a578cc4f90f1069a52226b733e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c0997af033577c07b56226b465f90772354b557df20f58a1ef93fe2ba1f0087"
    sha256 cellar: :any_skip_relocation, ventura:       "8c0997af033577c07b56226b465f90772354b557df20f58a1ef93fe2ba1f0087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524309d2141bbba0a6860fc475a8c11f72617aff9a236cb3d206ae2987a631ef"
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