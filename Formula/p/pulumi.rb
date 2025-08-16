class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.190.0",
      revision: "1189a7d9b12966d938c141c695252005325f4d5c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6a5d0b9e7b887c496c19a7b8dadc96d89d1c3bb6d13d06b2565a19e08169dc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b94bfc3ae62695708bc30d0c3720e1722056a26cfeea21a402c84ceb447970d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c4d770b50f026679d7166ad6859817e32909c7d2b3f64893496f5a5a45ebf37"
    sha256 cellar: :any_skip_relocation, sonoma:        "b94a1533862d6a86c14ab0e29a68b37f6d980e81c7825a635d490035f3a1c3f4"
    sha256 cellar: :any_skip_relocation, ventura:       "c3d80084c7991a36d0b260c2e7e2a60923107682dd83bba10a8a44b7561cf9af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766d501dd7eb84748f81a53285194f68738c5f9cd363d99133b2e990d1cc942c"
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
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end