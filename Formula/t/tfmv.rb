class Tfmv < Formula
  desc "CLI to rename Terraform resources and generate moved blocks"
  homepage "https://github.com/suzuki-shunsuke/tfmv"
  url "https://ghfast.top/https://github.com/suzuki-shunsuke/tfmv/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "e52be4c9f27e3a100aa06e2bbf7b3836ecad4614fe4a6b68969ef33b0bc2bebb"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/tfmv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce71cbfaca6ea720434fbaa9c86aad09c2676417300962540b5d6f2800d1775c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce71cbfaca6ea720434fbaa9c86aad09c2676417300962540b5d6f2800d1775c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce71cbfaca6ea720434fbaa9c86aad09c2676417300962540b5d6f2800d1775c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b6ae04d00e1ac6aa41070d05ea1f1c3360c6cdd57c5362c93efd36a429d1828"
    sha256 cellar: :any_skip_relocation, ventura:       "5b6ae04d00e1ac6aa41070d05ea1f1c3360c6cdd57c5362c93efd36a429d1828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9275a0e10a80e504cce76ff75a8cd22fc8d547e645d1f345706c2d15b0c11de3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tfmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tfmv --version")

    (testpath/"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    output = shell_output("#{bin}/tfmv --replace example/new_example main.tf")
    assert_match "aws_instance.new_example", JSON.parse(output)["changes"][0]["new_address"]

    assert_match "resource \"aws_instance\" \"new_example\" {", (testpath/"main.tf").read
  end
end