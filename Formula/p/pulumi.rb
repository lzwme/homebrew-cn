class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.184.0",
      revision: "a8f88047ab64d0048a24926da4fd34f7c28e4cf4"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83c4e5f3ca7b6ccdf1fee102ef6f9b2eb1654a31a6ba9a737dd3000420c7b019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dbb98ff52f5500911a8aeb983354f595b92430e7d71d6e9ecbc035d2546b66d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28c092b7fb636553388a0f3a7e74b24daad91d58ef1f529de8aec0f7cf63eb63"
    sha256 cellar: :any_skip_relocation, sonoma:        "6de67b3cab8b6e62cba23082c747bc4971b5d96a8004b5ff67673fa095aa71b0"
    sha256 cellar: :any_skip_relocation, ventura:       "d3a91bd884c0959aa2b6d0bb28b2335b2c91d973c6306dcdf3e4b2c42c576cec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565c0386c25e042f2a855f92b2ea52c1f2adf06b32cf5120dad25fe267ddd004"
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