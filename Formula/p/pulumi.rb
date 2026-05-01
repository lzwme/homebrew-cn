class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.233.0",
      revision: "fa313013d027a12af562c376e44eb7092df14bcc"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd3d3c037184e6e926f1039ca3d7b446933d21ef7a880cd5d313f94090e084d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2459ab06ddec735dd332ad95caa08b60989ec8f42b7f9106303c42d28b3d1af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fb99d0b5f932e23417caac69ebfca9d78bd7c63de57c75f2cc6faa1ea738550"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fab79a4ce3ab5c75df409da52234047670013e09ccb2ea59c1492443d9f935c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ab9dcc19b9b803cc721f47ab6eaf40147ec7be5ddd6e3edc7908be7d56c5afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a565ed1e200afeda63fb98c641e47a13551f35654e1699cbc237264cd26b1786"
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