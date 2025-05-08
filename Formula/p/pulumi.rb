class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.168.0",
      revision: "800c710a9366c3bcaa213f5765ee887ef17ef508"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08fbbe5280c121730067626ef3efe6274154431cf1d73fef5b6ea898eab42238"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e947c9999b25799dea45637f1618ed536b12e20e99f37a49abc1d5fcbd0aa325"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2f2de40b037247f50d656d9f0118793354867d21cf5036333ec474f4d40d624a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0197786250ce1fd6ec10a0f0e83aa50eff3a51b719dfab977560b7a374b6d8ed"
    sha256 cellar: :any_skip_relocation, ventura:       "bc1d1cc5f0a008bbf6f88a0b5536ddcd7ba2499d0f447f55263fcf43ec0f2a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25046643bbcf33cafe051abe898e70e43aeeb915b7b94754ebef36715a72223"
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