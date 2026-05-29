class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.244.0",
      revision: "fc6566b9250dbf68102845fbc119be4853acfae7"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a7ea401d58ca935d5842ad2302e078eef49ca4856d3b69f1886f7407a6d5c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "505990ed08cc241df4d93908de7c4648229573599fa97d4cf098745c079fec47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6586d65de2e349ae9ddbe6be5280bfb2f948427a98c3766f161d187355c3075c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e66cd81ab94419f4c0a89ef385fc690e49b5cd31b236ecd8fd79e7360eeb89b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6ce5f8874313c087d12c31cd7d67c5f47d0fc5b75fb2b024c7258fd9433ce55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb7597e73dfc39343ab6ca781c4a7aacd464207d9540ed9e1534773a9e84a58b"
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