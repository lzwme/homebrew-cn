class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https:github.comRoseSecurityTerramaid"
  url "https:github.comRoseSecurityTerramaidarchiverefstagsv2.3.0.tar.gz"
  sha256 "3a0651fabd83b854d1c5c03635fdfb027b19c598dca20cc0670f8c56b0ef7f70"
  license "Apache-2.0"
  head "https:github.comRoseSecurityTerramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd89112234b3be2e2443a63a77546b7fe4cb3acd87853b70372b9d60c3874f21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd89112234b3be2e2443a63a77546b7fe4cb3acd87853b70372b9d60c3874f21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cd89112234b3be2e2443a63a77546b7fe4cb3acd87853b70372b9d60c3874f21"
    sha256 cellar: :any_skip_relocation, sonoma:        "647b7f6c6d4038e2069411f7d56a0bf1471e28c6dd23b97a6a9051dbb5808dc3"
    sha256 cellar: :any_skip_relocation, ventura:       "647b7f6c6d4038e2069411f7d56a0bf1471e28c6dd23b97a6a9051dbb5808dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29078aa516ef374d946859737da8b1b4630f6bd9087d64715552ce5f83e7764c"
  end

  depends_on "go" => [:build, :test]
  depends_on "opentofu" => :test

  def install
    ldflags = "-s -w -X github.comRoseSecurityterramaidcmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"terramaid", "completion")
  end

  test do
    ENV["TERRAMAID_TF_BINARY"] = "tofu"

    (testpath"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    system bin"terramaid", "run", "-w", testpath.to_s, "-o", testpath"output.mmd"
    assert_path_exists testpath"output.mmd"

    assert_match version.to_s, shell_output("#{bin}terramaid version")
  end
end