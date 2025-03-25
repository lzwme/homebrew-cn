class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.158.0",
      revision: "bae605f7e0c69f00fe7dd43f67f97c8432f63966"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02f7f60d2c59376a0a5771b079913492b26c70b56ef6fd334cbacfa706d73106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8a9b8e84410dd16810cfa239e54a5d012d76c6aa5b66748fa9cbf0b8a97419"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a70124923bcf23b6cd06bf1acd628fdc7413fdcb12b8b4df5aa87d22ff411c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "efa9b919fb57be7b92993d6741f809172f4c5471950efa8b07bbb1c150541479"
    sha256 cellar: :any_skip_relocation, ventura:       "64b1a40a0258400184c62028063de96e24e6690b9c1204869225695ab78a1f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af9f604f131178de313dcb089a4662eff8d76326693e0c014a3da94ca933d39c"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    system bin"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_path_exists testpath"Pulumi.yaml", "Project was not created"
  end
end