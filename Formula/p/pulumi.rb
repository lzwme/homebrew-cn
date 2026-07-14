class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.252.0",
      revision: "31997188e2caf0b75a4e50d77574215fd42d7f8c"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "168e14732d9f48b2d62c48c19c99a4fd8b472fa15f5b420392cd7ae209ed3b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34b397b450b73cd17b18bdbaa61bbebe9b8c19905d40b0267cb3d0a3315f1027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7987cd12305c683125932980f701d108354d2803b7539a3b54e936937373a457"
    sha256 cellar: :any_skip_relocation, sonoma:        "dad531e779e4c0f25d2c2a3a7e955cf3617d68e92f3db1a5cd68031aeacd34a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5f96529537259dc3263e4c1205ce681584724705fe5c4dc20bb846edbca59c3"
    sha256 cellar: :any,                 x86_64_linux:  "0260022c2d5f6cc283e7367b5140bf3ad05cdb23d3dea3bb1f562570e942344f"
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