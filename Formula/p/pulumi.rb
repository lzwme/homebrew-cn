class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.241.0",
      revision: "46b066cff91a30ca1339c7f9379aa31f802b8399"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "343e2203f13694a2957dd11fd41b6ddf34c7439e63df7965f449d540ede92eef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ad173ba4a3b94b3248e27bf6b7946210e5bc354ea5431bd56f2f09b92f677f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b9102e8aaed720046bb89c3563133000024bc093dee19f947a8ed885c9bd1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d38bdd3b2298929709be188676ac21abd7fd794e82763c5899c155865b04480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19d0fa2b14a2f811cb60c386c04475490bbbcc43a0542bdbeeb56a431c4b2f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f666ad7b8d6115fdaa69af1e3d70ee01e91ff42864a283d67dbd6ef97e9f19f8"
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