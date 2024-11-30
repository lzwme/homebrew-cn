class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https:github.comRoseSecurityTerramaid"
  url "https:github.comRoseSecurityTerramaidarchiverefstagsv2.0.2.tar.gz"
  sha256 "1ddf7f16d12e96b3169f92e78415337d76edee9e9576b03f7b844615cb2daaee"
  license "Apache-2.0"
  head "https:github.comRoseSecurityTerramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c439ac1215c0344015e2c027a36240c97a339ae1878466cb3821b1a360094616"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c439ac1215c0344015e2c027a36240c97a339ae1878466cb3821b1a360094616"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c439ac1215c0344015e2c027a36240c97a339ae1878466cb3821b1a360094616"
    sha256 cellar: :any_skip_relocation, sonoma:        "45347c94c895dfe6ab06022bdb1b645bdb9fcfa92c47e686c9892d2f9cc63375"
    sha256 cellar: :any_skip_relocation, ventura:       "45347c94c895dfe6ab06022bdb1b645bdb9fcfa92c47e686c9892d2f9cc63375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c7dcc481717cef4596739b95ded0246e5d5951258c34d9b3fec4b56aabae4c"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = "-s -w -X github.comRoseSecurityterramaidcmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"terramaid", "completion")
  end

  test do
    resource "terraform" do
      # https:www.hashicorp.combloghashicorp-adopts-business-source-license
      # Do not update terraform, it switched to the BUSL license
      # Waiting for https:github.comrunatlantisatlantisissues3741
      url "https:github.comhashicorpterraformarchiverefstagsv1.5.7.tar.gz"
      sha256 "6742fc87cba5e064455393cda12f0e0241c85a7cb2a3558d13289380bb5f26f5"
    end

    resource("terraform").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: testpath"terraform")
    end

    ENV.prepend_path "PATH", testpath

    (testpath"main.tf").write <<~HCL
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    HCL

    system bin"terramaid", "run", "-w", testpath.to_s, "-o", testpath"output.mmd"
    assert_predicate testpath"output.mmd", :exist?

    assert_match version.to_s, shell_output("#{bin}terramaid version")
  end
end