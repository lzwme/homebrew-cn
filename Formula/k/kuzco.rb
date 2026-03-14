class Kuzco < Formula
  desc "Reviews Terraform and OpenTofu resources and uses AI to suggest improvements"
  homepage "https://github.com/RoseSecurity/Kuzco"
  url "https://ghfast.top/https://github.com/RoseSecurity/Kuzco/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "521c7c4d1684bf9fd4b7372979d14377b59312ead32a333e6473b6fba3e21e63"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Kuzco.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5f01601303e0293d774622d063c7b3740281ca048415907366d27ff7acdfe07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5f01601303e0293d774622d063c7b3740281ca048415907366d27ff7acdfe07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f01601303e0293d774622d063c7b3740281ca048415907366d27ff7acdfe07"
    sha256 cellar: :any_skip_relocation, sonoma:        "405515ed9faba2716d19d4680ea046734ba42b1dc97269312c22c948867f68e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c73a946eee7af115dbeb7d6dcbe3941c1848d5c77e8af700feaf1673da48af38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "227cd0eff2210ce23b18aeae7e4813834c60fa3daabd885d107c1fe8af321fc7"
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