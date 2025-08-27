class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "602594977dc0499564389db28aba57fc1c431d060133cc16942c087587018e9f"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7335adf0af9aec226f576e4c63bc476ef809ff35aab591dd9136a3603e26b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d7335adf0af9aec226f576e4c63bc476ef809ff35aab591dd9136a3603e26b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d7335adf0af9aec226f576e4c63bc476ef809ff35aab591dd9136a3603e26b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5a8610e7841bc1800f041c69779679105a9c8caee060a2526e7f7018fbfa534"
    sha256 cellar: :any_skip_relocation, ventura:       "b5a8610e7841bc1800f041c69779679105a9c8caee060a2526e7f7018fbfa534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54ea3cb0d705a2ed687aa69a3392790af9f7deb1f1e3b0e807c8e97c3cf05a69"
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