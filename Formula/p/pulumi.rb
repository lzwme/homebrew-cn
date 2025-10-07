class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.201.0",
      revision: "d31eae035cb90b6f400207edb3c21259f9c6800a"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24221b24c88fd6a2b60c5ec345cbb89e948799ab1af943d9c4fbec5fea7e5d9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2effcf99c5caa38533c4c62af75ae065cb69a717591a3b7efc3af4cef4f53176"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa46c67ea9195199dcadd6c920ee8fa07a6dbed96702269796ccc58d502ee255"
    sha256 cellar: :any_skip_relocation, sonoma:        "577bd4feb3734cabe01a17118c9ef33e0762ef0edcb5e2f159e5648980893500"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67262c6387570935f9f6f3f9e43b6052d97cf36c4cb83d345dfcf6448a8482fe"
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