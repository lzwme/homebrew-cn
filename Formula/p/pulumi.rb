class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.217.0",
      revision: "91dd185e1283714592f959fb3725e8d6c6cec2ba"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5244ae44dc88619130e0c518c9434eac2374b21f5faecf0c9deb730e43e910ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4184a7e6bc18a06e60b899d2ec1fe3f36d5f5c697e367e90208d1ac98a07a258"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e68387c1e749b466f028597ad85f5199faec1990735de7dcb3ac4de464ce1c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f5594e306623fe6abd87ce1b252a7e6c66cc683ad3251c37bcb9eec0cc3dad0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d98933bad7aab6ad3e9454e1b7aba430932b40c877426214ab9e63c65da478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4ac3e5f873079bc77b031d707adf4e0b758b2468e42ae82a9f93c9794f4f3f2"
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
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end