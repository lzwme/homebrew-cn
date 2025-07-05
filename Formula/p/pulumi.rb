class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.181.0",
      revision: "c53ffb7ac46c37cba575096f5c166dcfee74d282"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6604b5d903d69162425f509ee98f344f7f0abf9abf6712ee38ffee6ed2a515e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711af81550b5db7ef504d9c3dd4eb601180c68ca16997fe10bbcf0c1024f74d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e3f5e6aa88b3d651d4d62f888af5329f303065b2de7dcdb54da7be56443ffea"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecf650819d7d828110e4ae41c69f29b8fce50ba6d5349f86ad590611c2d243cf"
    sha256 cellar: :any_skip_relocation, ventura:       "76f69423e71d9f9c1ab3046f599e7fe14103dbda65f909fe7d95f4fbbadc397c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e44008085084f1e377c9cc4b77677066f201bfe5b265902e64e8e423af7f8e"
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
    assert_match "invalid access token",
                 shell_output(bin/"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end