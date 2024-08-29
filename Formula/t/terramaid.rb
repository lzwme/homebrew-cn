class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https:github.comRoseSecurityTerramaid"
  url "https:github.comRoseSecurityTerramaidarchiverefstagsv1.11.0.tar.gz"
  sha256 "992563cd53d7ce64db3734a839a3291f6e1950458ab72a13eb382c8f3c403afc"
  license "Apache-2.0"
  head "https:github.comRoseSecurityTerramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51d9d515006cd708bb829d397effe5e0e18f23d9c6ae375b7695abd2626fdb19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51d9d515006cd708bb829d397effe5e0e18f23d9c6ae375b7695abd2626fdb19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d9d515006cd708bb829d397effe5e0e18f23d9c6ae375b7695abd2626fdb19"
    sha256 cellar: :any_skip_relocation, sonoma:         "f43cc2a478b4443aabfb89612914aa6f16d2682bd06a436dc69268834fd2477b"
    sha256 cellar: :any_skip_relocation, ventura:        "f43cc2a478b4443aabfb89612914aa6f16d2682bd06a436dc69268834fd2477b"
    sha256 cellar: :any_skip_relocation, monterey:       "f43cc2a478b4443aabfb89612914aa6f16d2682bd06a436dc69268834fd2477b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f887d1b7aca22350daa8f156b79a9bc39db8ca202cee8bd5ee65f233bc3b30c"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

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

    (testpath"main.tf").write <<~EOS
      resource "aws_instance" "example" {
        ami           = "ami-0c55b159cbfafe1f0"
        instance_type = "t2.micro"
      }
    EOS

    system bin"terramaid", "-d", testpath.to_s, "-o", testpath"output.mmd"
    assert_predicate testpath"output.mmd", :exist?

    assert_match version.to_s, shell_output("#{bin}terramaid version")
  end
end