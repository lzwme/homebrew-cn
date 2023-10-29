class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.91.1",
      revision: "13e584ba91eb9ff39be4be844dcd767f93c18445"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cef5cc8e8a45ed2bb36fded10a948643cf70b56c66ee189bece6edaa463add3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52d89779447042dd739a7f900f7ddf7ab11e51b117c7525c0d47639d4a512873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcf1546acb80e71b4a4e6355f03605ffb37ef5cd8856e2499048c9414bbc92cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cefb8fc31e1cddd62a20fcd912241682ba8daf171e35711b36b7421e4fdde0a"
    sha256 cellar: :any_skip_relocation, ventura:        "8ac0aef842da68fc83794b0b619d7deb32143b6248af7d68a4be14a700ca59f5"
    sha256 cellar: :any_skip_relocation, monterey:       "c84586594eb6f1fa99934c476f4281f2d022b75b335796feab80b4516695b31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fadfc76200fcbca0c2e313b31ee27de9c62f5ca1edfc0c4af6348d5c9a3b822"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end