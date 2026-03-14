class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.226.0",
      revision: "94ee966f0f3e4d1207c1a1bbe5b0b5ffd123c5d8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f2ef883d7ca3345bb97a997423c91d3b918003b1c79da0fd136a101a1c7b450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9610055499992f8960ea8c76950d4e7ebeda5ba7b91de38a768067c15d69609"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7234ad71e2a8ff6d931568977aab594a0a2a0fb85916ecdbd10a4e01d4f02454"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9b8fe4ef4d941b9ad54cae40984b741cca887b2f876dacce227e30e6dfacc4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "389e2ee47e5d5016d5b14a1b35325be279a2914b52cdd9bc4a34a1a428497efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04a97212b99a2cd5f226bccae000ab10c58a9a7c7552218b5cfb619d1c45565a"
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