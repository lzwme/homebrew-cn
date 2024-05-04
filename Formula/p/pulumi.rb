class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.115.0",
      revision: "a80ef4fc16e2d207f3f9b16e870cbef92e4b250a"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daef45eed51d4e1c016575be23bc606b8908d055eff39d15a8506dfeee93e43e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "487221367330a242620a48bf187d74b8501b52a98b475f40b2648ffb03ff2623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4992b7be5445f8cbc2640162b4ee8b0994602a585411aba9ed8fac4ae0360d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f84b875e37e6259d4f2cc1776f9b8b08211dcb543739d45ec2724ae7f460df49"
    sha256 cellar: :any_skip_relocation, ventura:        "5cc8a97c47cce41431f7e7a2ec90b06442a45091bb175576edf13cb89e07f36a"
    sha256 cellar: :any_skip_relocation, monterey:       "860e1de3daa73dbb67dfaba5f7a176570c2dd7e093da03c2a929f295df220a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e03decb481b20d685e59c1ace492ad92d166209146d3811a69623c69ba6daa5"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    system "#{bin}pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end