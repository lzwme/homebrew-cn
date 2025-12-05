class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https://github.com/RoseSecurity/Terramaid"
  url "https://ghfast.top/https://github.com/RoseSecurity/Terramaid/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "dfb680bc2fa76a036f7ecd687450333070ce791343a75c38880c0c5f631320a9"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/Terramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37df2b39e5fe265072242f5a18669c92e23835429d97aacaa375a5ff1c7171e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37df2b39e5fe265072242f5a18669c92e23835429d97aacaa375a5ff1c7171e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37df2b39e5fe265072242f5a18669c92e23835429d97aacaa375a5ff1c7171e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1db92ccb63a0c3a6a9b3faf3f052814af175d5a2e6fc1a0b4f3fd1459aede93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9a4b36a86ae350675abfd2eba7a3bb4a875983ddde8b7a38b9512932cd9d094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2fc48a90fcbc281637cb1604f90b9837aec8676e854e3e6489c466e0c4c444"
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