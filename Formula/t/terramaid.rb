class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "531f205d9f6b6bc53a43acd0289b767d06c45a665c3f5ab7054fac4d28fabbe0"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10d2e519a40ec4a723a83b106130a57ae9481851d777664df01765c5d5e3d6b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d2e519a40ec4a723a83b106130a57ae9481851d777664df01765c5d5e3d6b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10d2e519a40ec4a723a83b106130a57ae9481851d777664df01765c5d5e3d6b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba7ffb9af8f1e9e25b2e3a93141841bed7c91e4400809d454975a8a17f16d8a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa72c21b437c66426b6c20da4913b366ebf533c0b17bcf5a4ab11b88b7df7add"
    sha256 cellar: :any,                 x86_64_linux:  "a82d85762a42df673f8c8ccbd5da693d3e853f3bba5358eee4da917ea5517465"
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