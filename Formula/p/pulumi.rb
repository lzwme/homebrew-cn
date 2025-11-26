class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.208.0",
      revision: "2134db3da537219feabe3b7a1631303dd7f1fae0"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f5c4d0f7d6663bd94885312ace5fab48118e470ae4a1c554148e960c8afeec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd5081946390f7d70bf3aeed2ca0db3dddd358fd2f3ba25708fb7f22e9de3de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2e2311b4df114b25fd310846d6829c70967713dffaf38e061bc8f93736efce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7897aa51ab97790addbead633a26a8854363099d3a6cc1c7387782eeedbe1b59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b9d5899b1f9cc2f7bc7ea91d131d2bedc5f31f42083532f1d34ff7f4db5a191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "261c78c404ded2abaa13f6a954cd4e075001e38dca2dce212d602e481d0ec472"
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