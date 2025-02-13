class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https:github.combfladtfproviderlint"
  url "https:github.combfladtfproviderlintarchiverefstagsv0.31.0.tar.gz"
  sha256 "9defa750077052ebf1639532e771a9e986b7a53948b6a16cb647ceaf60cfbce1"
  license "MPL-2.0"
  head "https:github.combfladtfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8a842d454ed661bacbc63d64cf741cb0009cd5ce8c4e2a8bc6d6459bc721252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a842d454ed661bacbc63d64cf741cb0009cd5ce8c4e2a8bc6d6459bc721252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8a842d454ed661bacbc63d64cf741cb0009cd5ce8c4e2a8bc6d6459bc721252"
    sha256 cellar: :any_skip_relocation, sonoma:        "2105a162d222608f8b6366c43367d89821e40d187e60f303d26165f2149a9069"
    sha256 cellar: :any_skip_relocation, ventura:       "2105a162d222608f8b6366c43367d89821e40d187e60f303d26165f2149a9069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc744960d7e4d5eb0cb62edfec08243469eed81700a99a5a33fb31a8e215354b"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.combfladtfproviderlintversion.Version=#{version}
      -X github.combfladtfproviderlintversion.VersionPrerelease=#{build.head? ? "dev" : ""}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdtfproviderlint"
  end

  test do
    resource "homebrew-test_resource" do
      url "https:github.comrussellcardulloterraform-provider-pingdomarchiverefstagsv1.1.3.tar.gz"
      sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
    end

    testpath.install resource("homebrew-test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin"tfproviderlint -fix #{testpath}... 2>&1", 3)

    assert_match version.to_s, shell_output(bin"tfproviderlint --version")
  end
end