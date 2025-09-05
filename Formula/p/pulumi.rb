class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.193.0",
      revision: "dd543e3959133a99f74226be0a46d7565ca9fa6d"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33233eaf39ca02a78164d97954d8daaeddabbe71d0c126ad0cae8b030db38749"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e294d6c8f3d8f787b4bd8502ce568624caf953cc1f9133324a87cf502d772384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "caa9668e628b348a32cbc75138bbc419975b4443e3d02a3475fc71de9411c65d"
    sha256 cellar: :any_skip_relocation, sonoma:        "118802b14472ae6b079c9b20486d1d288f3dcc3eadab6b326107c47841c00f8f"
    sha256 cellar: :any_skip_relocation, ventura:       "e600022b9246c54f8999a91a0043fe79c6c435e21fa5109d150387990ea05a6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d01205c2c8f224a46442228d00a0f344a07259242e038f2d4ff657838236219"
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