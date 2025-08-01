class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "d9733bbe9a9df2736d654e5ab3fa9caf7448e82a1ae23f581f5cb6f59fd50a58"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7787c7075fdd691b13931a8b97743b41f870036adb8ed4c885c33062a757a5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7787c7075fdd691b13931a8b97743b41f870036adb8ed4c885c33062a757a5c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7787c7075fdd691b13931a8b97743b41f870036adb8ed4c885c33062a757a5c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe95cea017e17aa63099bda44dffc417b8bb05ec7215a4547cecbc9cda3f942"
    sha256 cellar: :any_skip_relocation, ventura:       "6fe95cea017e17aa63099bda44dffc417b8bb05ec7215a4547cecbc9cda3f942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6859739e67e9d0831e7d2445528d47fed935a737de9c8c5d62c94266c4c3e2ff"
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