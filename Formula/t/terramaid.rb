class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.15.2.tar.gz"
  sha256 "c74bc24a1125c8e7a5c64dc86111970aa9bca395be8b29fc00ec4e72e97f3e5b"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddaee9ca3fafd1f94f38a57f306201abd265506f278d3d511d6232ce80a003e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddaee9ca3fafd1f94f38a57f306201abd265506f278d3d511d6232ce80a003e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddaee9ca3fafd1f94f38a57f306201abd265506f278d3d511d6232ce80a003e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8c2353789ce66fb7f24a3e4a3ea7e522a80690e8f4fa347fde3d4e3857f3f07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55effe6bad759015b1ad5b2eb7a9778c4cf3ac352723e2877bd42bdf7a86a801"
    sha256 cellar: :any,                 x86_64_linux:  "2f9c64ef11aef900ef678682fd2d1f158e7c45f0ccde2cd7ec453fe45fd8ee54"
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