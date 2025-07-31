class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "3415bae95e17556bfcc21893c494bd536523b5fd071b70ffa5068bad3490d11a"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "745edccac997c5120f8648f3661b2310a8e6765c412239f08576244999670946"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "745edccac997c5120f8648f3661b2310a8e6765c412239f08576244999670946"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "745edccac997c5120f8648f3661b2310a8e6765c412239f08576244999670946"
    sha256 cellar: :any_skip_relocation, sonoma:        "9caea5f8dcb3d31c459d0e1c6a9ffc06bca42012b665325b1e0b0b9d53844aa8"
    sha256 cellar: :any_skip_relocation, ventura:       "9caea5f8dcb3d31c459d0e1c6a9ffc06bca42012b665325b1e0b0b9d53844aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ad7c19f8ac45fc471bc54a9bc338d6f5a2adb2a23c3f0ce8e087767b5f79e2"
  end

  depends_on "go" => [:build, :test]
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.com/RoseSecurity/terramaid/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"terramaid", "completion")
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