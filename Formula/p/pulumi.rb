class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.97.0",
      revision: "5580052298df957e4bb06478f0e88fd513e19988"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b3ef953498f4800e82d43c20c903b10178cca008a2e3ce16424c908b66444c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "858c6affe9e11f76ae65424c472a516a26c9647b6400fdf681843ac2136ee601"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ed906254097a5558f7f1f41fd3ce0d53d0d9648de3dd3bf533eb89845c195b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2291c048e97f9d51c155eee839d10fc980210b1d11e59d357cc12d5155820b5"
    sha256 cellar: :any_skip_relocation, ventura:        "ab2a984a9bcc4e87ccd6086d048479f17f5906eda03d6410837a2e98e6fcd459"
    sha256 cellar: :any_skip_relocation, monterey:       "883a499a4889260a825477b5a4bc13f1dae7935b76ac7bca871a0779068f6bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d47c6fe13edcda3b37d1a25f99120adfa2f8f6cca8d20f57bb6ddcc4d823dc"
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