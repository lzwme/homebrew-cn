class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.65.1",
      revision: "f4044dc955009a7da3d58f845ec29a9a7f80ec49"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0528949ab433a5d355f1d817ef3be2f2a0b14e8bb1c2f715debbd59def3b3d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e338d2cee9e872880a3b4dedcc6c081f2023cbd40732312709a756b57d1d7d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f8afa4852668b5af5795be76deb825dacec3f5cbc7508beffd71735a10b609b"
    sha256 cellar: :any_skip_relocation, ventura:        "5960fc952153a9ef1d81f88cef6db18e05813fa88b628cbe44b5de20331a7d41"
    sha256 cellar: :any_skip_relocation, monterey:       "db1293fe727d063dc4c352f3e9f3007b34ce2d323006f462626a39e436a129ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "90d5bf6156123d09f2a9f3ee12d6eaa5b207821e60e3d5884d4e91739a3599b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42692273f2ffb09326b5f0e20365ab71303007acd061cafadf3938d2a652da4a"
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