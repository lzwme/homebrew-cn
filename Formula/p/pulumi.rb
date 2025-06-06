class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.175.0",
      revision: "0b83ce113e31f415887b5221a97c1b375585efd6"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6f41dd3ec75574bceca95427bed3e010f281ced3c34e7293b99dc4a0a571ebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c696d2fdef86383cfabdc2597fb59f1cb85e05081304c3f862d166fa69370ab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4165a6d97ee475a86e34cee8e0f8782ef314aa2223a53abff7b78e6a95e4d99c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e51d1f103aa5ff42a5295bfb149de7159a36cd9646c9419ba5a02ec19ba65a7e"
    sha256 cellar: :any_skip_relocation, ventura:       "133cde3d2cbde8f235fdf8b02422a9196046d318cb7e1e85888104f96ba6e958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4b2d32724aaf745631311fa5171a76db84aaaa00536797421daae0e0b00069"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    assert_match "invalid access token",
                 shell_output(bin"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end