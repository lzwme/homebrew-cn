class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.229.0",
      revision: "4a1e067a15f35e64a220b2a49cb684f0df1b19fd"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b645f25a1d5d64a3af90ffef3a4710978d9e9d70143b6ea18fd85f0911c2ad7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5540b2e30395653fb4eacc22c241132aaa215d010c2003020b05e5a62c9d547"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bae69b8e354afdcda7a9d3672f5b78b8cde56052587601993cbfad7a13b07e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "87d768081a81df35ca6bfeccc0deabb58276ad6822cf7ebabb5258a608656591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39a536cf69735ec4cbec15e7ad2666cbe2507c42c92b05aed4ef9e7a39af3710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d21f9e874f3286498c09b0333f325b77f0325192680f3713e71d23529a2f498"
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