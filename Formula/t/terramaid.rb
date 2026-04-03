class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "241642fdbd0565f441e4d4de8fc2165531a8a9d554032ed3bf9d81911f2a786a"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1465c5351e78981e984a4aa64500e8b78cfdca6492fd384f15a02091be15ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1465c5351e78981e984a4aa64500e8b78cfdca6492fd384f15a02091be15ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1465c5351e78981e984a4aa64500e8b78cfdca6492fd384f15a02091be15ff9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fb66ecc66fa76a67fd4b76dfd9be501d21d5eb0e6ab1a8503cf9ead87767dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ce1ee20edfaefbb5cf90f8a797ae1673563ccd55e34bc46e1ec43ef18531595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9351baaa7829073ed9782f7d3680d1045e56ae78ce3cb7a095fa92a443a3e5cc"
  end

  depends_on "go" => [:build, :test]
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/terramaid/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"terramaid", shell_parameter_format: :cobra)
  end

  test do
    ENV["TERRAMAID_TF_BINARY"] = "tofu"

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    system bin/"terramaid", "run", "-w", testpath.to_s, "-o", testpath/"output.mmd"
    assert_path_exists testpath/"output.mmd"

    assert_match version.to_s, shell_output("#{bin}/terramaid version")
  end
end