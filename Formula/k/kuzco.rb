class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https:github.comRoseSecurityKuzco"
  url "https:github.comRoseSecurityKuzcoarchiverefstagsv1.2.0.tar.gz"
  sha256 "70baccb282e25d74a1d168e3e8e1786431690df9639ca6ef9701f3fdff12a3a4"
  license "Apache-2.0"
  head "https:github.comRoseSecurityKuzco.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "637f33422371e8fcc9818fa2fd5da70e10ee7d815a03653b5bae79cbd213f31d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "637f33422371e8fcc9818fa2fd5da70e10ee7d815a03653b5bae79cbd213f31d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "637f33422371e8fcc9818fa2fd5da70e10ee7d815a03653b5bae79cbd213f31d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9226f4956a1a4de5f8dcc1032f3db14e70668556ee017a96c1f19532dc8b6968"
    sha256 cellar: :any_skip_relocation, ventura:       "9226f4956a1a4de5f8dcc1032f3db14e70668556ee017a96c1f19532dc8b6968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566e16cb696c36c21af391f39763283d8e42befe05edaa1691948c80244d9109"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.comRoseSecuritykuzcocmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"kuzco", "completion")
  end

  test do
    test_file = testpath"main.tf"
    test_file.write <<~EOS
      resource "aws_s3_bucket" "cloudtrail_logs" {
        bucket              = "my-cloudtrail-logs-bucket"
        object_lock_enabled = true

        tags = {
          Name        = "My CloudTrail Bucket"
          Environment = "Dev"
          Region      = "us-west-2"
        }
      }
    EOS

    output = shell_output("#{bin}kuzco recommend -t opentofu -f #{test_file} --dry-run")
    assert_match "version block", output

    assert_match version.to_s, shell_output("#{bin}kuzco version")
  end
end