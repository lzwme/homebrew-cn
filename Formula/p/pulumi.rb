class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.170.0",
      revision: "1fa4acd0d6e5c3edcdb1454f79d8e18c7c3d895a"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "530b040014a8a2e77db6429645e036c5c31c8b6a7e82b6a3561924397c535508"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c601e26a95beecb7934f3f5a722cffd4b102fe4824f5cd6021f7c42ef7c39fce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779d1d0c328e80932e785c23211e95dedb70ad7f2bafd944f8ddce9947bda7b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a92b2497ac1b78eddc324dbc352106b86333ad1718be9ea06bffd8a2aca73c20"
    sha256 cellar: :any_skip_relocation, ventura:       "fae7891d5512363b52fd1018d6594cf5470a175184b63dc7c324a9d69318529f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e41ab4901f63b41620ddadb199d75cb2393b05a34eba45413b4ba343b47c3dad"
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