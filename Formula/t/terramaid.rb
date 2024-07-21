class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https:github.comRoseSecurityTerramaid"
  url "https:github.comRoseSecurityTerramaidarchiverefstagsv1.6.3.tar.gz"
  sha256 "0e8750330f12650d2737afdb5cd7d480858ac8955206d47e0bbcce8ca84d17a0"
  license "Apache-2.0"
  head "https:github.comRoseSecurityTerramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f1354304e8080600354dcda1c9242e7485e8e3bdcb6ee31e209abee357a292b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21fc40af7dc399c781ee41d20d6e1f159eadb868df4701428fca4df3cbd19674"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86f9b37ba899db6518519b4c4bed800823b8974b6ef854a9f444120ca07a32d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "47f9869b712707749fd97411f6f64ef6afb09409c38590912717746befb32489"
    sha256 cellar: :any_skip_relocation, ventura:        "3ddd767871c0fac40b4e2e8302766e421a12a072b6bf9b883b3118603ced8be9"
    sha256 cellar: :any_skip_relocation, monterey:       "12eba948707333fa7cf3b8e60cebd79fabc0ffcc079e5ea3b3a0d77e56f3590d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf0037ec68955aa258eddf78b5c697f257a088362c5806a3f7b33229196a990"
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