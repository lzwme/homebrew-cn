class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.242.0",
      revision: "f4db8b5f55f132b62f70dbadcc45ea3492104af8"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91babd4112dbda4ee41be362ecf0f6b41267d082a38fc735553ab7462fb3ac2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a941c1664055aa9ebf570da9ef228386a88315153e1963ab7df42dfba3ddd3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "524ccdcfdc07dfdd60f94183e31bd1471985f0b7971f70bec9e5c2833a0f624a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0592c6117151e0d2cef61abca3860bbda90e7447b5c358af8361d8a89e41f90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa8e12d690f439c984d375bc3d2359ae7a5a0e03480be12a770961ef3469451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f075e8d2303ef84364112cf3dd5e9d62647204915a925a91364b5ff318126305"
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