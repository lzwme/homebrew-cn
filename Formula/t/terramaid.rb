class Terramaid < Formula
  desc "Utility for generating Mermaid diagrams from Terraform configurations"
  homepage "https:github.comRoseSecurityTerramaid"
  url "https:github.comRoseSecurityTerramaidarchiverefstagsv1.12.0.tar.gz"
  sha256 "18c667fe50d2e8488040f47fe8c9b9aa2fd570cd3edb81b630824ffb2d9d7ed1"
  license "Apache-2.0"
  head "https:github.comRoseSecurityTerramaid.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "128cfd282a6cfdebcb658b88160c4d302c3d85577e36f0a6691612b21080bed8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a5a5da4b221c36cc5bbe99c48bb07bfe397878415157b991ef402a50060fc81"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a5a5da4b221c36cc5bbe99c48bb07bfe397878415157b991ef402a50060fc81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a5a5da4b221c36cc5bbe99c48bb07bfe397878415157b991ef402a50060fc81"
    sha256 cellar: :any_skip_relocation, sonoma:         "2647a4665c8cd84843ecb491d726248f907c216dc693a67b16b9daaba19dbd74"
    sha256 cellar: :any_skip_relocation, ventura:        "2647a4665c8cd84843ecb491d726248f907c216dc693a67b16b9daaba19dbd74"
    sha256 cellar: :any_skip_relocation, monterey:       "2647a4665c8cd84843ecb491d726248f907c216dc693a67b16b9daaba19dbd74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25e9b8d7a958081966beedbdee66ef8879b7dd9a7e7151a17f95a8e88067b474"
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