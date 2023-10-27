class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.91.0",
      revision: "41cb5192383c32978f3508db175c0ea17f69f03e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8e5b57027020934e02bf8c60d7cbd4c437dafc341a871f9bcf3550f0150c1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e46e9f478bccae8c213dfa38599945c8b24b5bf74e0c557fe417d5477af3746f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60da35625c0cd27b817119f5b0b57c7a9a688a59baf4180d7ebf4a6d0cd0a676"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c16240a9eb3f53db31fa961c8ab139c6138924d8fc78be47ccfe52f4598e2ab"
    sha256 cellar: :any_skip_relocation, ventura:        "1d1b7828ec91e201437d9447ae4762fcfb9847893c9b47fc059342e3371735bd"
    sha256 cellar: :any_skip_relocation, monterey:       "e96e2d8f7636b46019e522871a32835b19e63167f05d13a62ee474f8202ddc77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e25223b6bb8869feb531588155cc8397a237784c46ec5e63ad4e9b9f58ce229"
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