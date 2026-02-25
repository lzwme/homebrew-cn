class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://ghfast.top/https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "b25457792693df0e53b2e36b9f77ac5b83a8377a5bf6c10e671483bd2582eb30"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "176c9b96744ec4e124b20aebfdbd0adab2acf7f0bff9dd7c08a294ae92ae15fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "176c9b96744ec4e124b20aebfdbd0adab2acf7f0bff9dd7c08a294ae92ae15fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "176c9b96744ec4e124b20aebfdbd0adab2acf7f0bff9dd7c08a294ae92ae15fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9ce248f4d9322f433d5b48e7a90d60db06920971717171eaa2a6f120284da56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a2ee10d34b20b83d1409f1f15ae96311c6f890daad7032b339c840fd5ce924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3fffefd67f030e20b69ce51d5edadea20cbbccb745c7f22489d0fc60a6daf2b"
  end

  depends_on "go" => :build
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/kuzco/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kuzco", shell_parameter_format: :cobra)
  end

  test do
    test_file = testpath/"main.tf"
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

    output = shell_output("#{bin}/kuzco recommend -t opentofu -f #{test_file} --dry-run")
    assert_match "Unused attributes", output

    assert_match version.to_s, shell_output("#{bin}/kuzco version")
  end
end