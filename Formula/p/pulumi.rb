class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.95.0",
      revision: "4ec6d6057bdaa512301752f3c1f2d605acbf54ad"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d3ec2d660ebf3c072ae5ed84f03c26233ecccc5dc55e8b752204c21f9c2554f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7c232606af76551bdf704d41d34eb1287d82a4d5d781bec9314a20bcc4491cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e940988705d1a7b06fb06e963adabe53b87500bfa2b6e7f94e7b3872c49d1638"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a55a059bed3835fff7f0043777a590451a5a816c3b51976912b3df1b7a29168"
    sha256 cellar: :any_skip_relocation, ventura:        "8eed8c2872323b40d8bb976ebfd0c066b1dbc57a64b6fb51a493ed8a83dbbd88"
    sha256 cellar: :any_skip_relocation, monterey:       "6693b379a96789d947a7fb16528a128db3bd483e04ca406c127f30c2ae1b660e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e401c9c7fe625021549ca9b3bae8912ef9e255f3ddacfb3f56892ee699db72e0"
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