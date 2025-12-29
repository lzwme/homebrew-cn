class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "dfb680bc2fa76a036f7ecd687450333070ce791343a75c38880c0c5f631320a9"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9689579cea79cd8ea6f890820c47c691aae16db01865a07546997d92d55969de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9689579cea79cd8ea6f890820c47c691aae16db01865a07546997d92d55969de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9689579cea79cd8ea6f890820c47c691aae16db01865a07546997d92d55969de"
    sha256 cellar: :any_skip_relocation, sonoma:        "213f96056dc226fe762c26605c18e3bca67892529b377adcde3dd5cd4f67c27e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0edc91e305e93ad62ca5eb320c78d1fd3c8b48f3d3f4747ebf2952ebe49c96f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf96aeb3d954eecd3c3e979496cb2dfb1fceb715dd0fd9c0397539d74096249b"
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