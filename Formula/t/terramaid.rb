class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "c6a34893d76f8f48def31ba2d7c139cc47d266697508afe70d7b1509be0c2ab9"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4869d6fb93523865cba003239815d10d85eb227ec17a97b8d8cfb3af2770339a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4869d6fb93523865cba003239815d10d85eb227ec17a97b8d8cfb3af2770339a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4869d6fb93523865cba003239815d10d85eb227ec17a97b8d8cfb3af2770339a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6692bff72e0a731fc5d8160ba3f4ce1f0b887d2cff387209da875107dc03054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dab5648abed529cf569daf20cbaf3eee2e5942c27515a6a5dbbee06e083beb68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1923bc279f793916d2f82638e1015f7252c5572c7ee4d65d72c4416b29ec1dc8"
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