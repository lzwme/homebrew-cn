class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.118.0",
      revision: "98d7246ea866a7e4054ca7c8a56926ed6451050b"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "182b44857795aa14f5fef16de31005abc87cf0539af181297551afdff77a9665"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "908c4fdf87a889f367f2123be68d9865592c2617448458523dd120e7382946ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f143321945c397b678a90bd5f5431c06ca221b71ba3d6ee2bff03a471c5d790c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dad2a713868eb9370085325a308a85a88d62ac7dba400878bdce25493f4f33d5"
    sha256 cellar: :any_skip_relocation, ventura:        "378cf098a726ad596a1fed36072f3eaec1da9d3a73c5459ef36eb962988379a5"
    sha256 cellar: :any_skip_relocation, monterey:       "1c58e104cdf5c77dd0a40d06b5e971e006d17781d65174ce54c7b3a10b842ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd1d72e884c03d0f76e977e6f2483a1bffecacf63d99fb0b38104a0afa6f3700"
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