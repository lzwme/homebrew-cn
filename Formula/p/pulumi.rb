class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.186.0",
      revision: "e37a2ea3f2571408f96a6145d09a22f287f47ce5"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "416ca88b5bbfbf7e470aa2a9fd80aef59f37dae9a6170ce1c4aebf00f0cb1433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69643c3e05f32ab3f241634bf00f4823b678031b4c81eeb62befff09a98b1cc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c466da49048b79405147848a1728e604e3127a30d1745524b4ced96ab9ca378"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf90363ac5ea345d908fabe4cfdbc1c3ad20acf99f85bdd43818039e1cf17fae"
    sha256 cellar: :any_skip_relocation, ventura:       "df201e2133788822b277f1c4edab5fe27a37d352a44946f37fac81a6176e4882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "264f801078f1c75f1b5f9c05a2d5541435547c4ed32e35244626fcdcad820cf8"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end