class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.132.0",
      revision: "81847fedf30a1dfe7e7dabaabf15d6ca04a53bae"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a662dcc77f75c8168f7e4d910ddd49f47d5ae4aab3cceabe283646ab69f0adf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc1412c70f86b533be9c69e57e79026e8a5ed31b17203ea79471f4974a2de31b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf7f3662d3bfe93fe9cce5c5a0ad1a4cc47eef49caaed94d945fccdadba81d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9154250b9a241e72feac27afb58a3e75020f7b192bd52db1f20c3ef1315195ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "86e6014c8c309c38196febf39092a5072f2f99526952f8bf1d07e8bcaa957093"
    sha256 cellar: :any_skip_relocation, ventura:        "0f543a28cee3ef42fec9aeaf7b1ec2027bf53c0fb47c33da0b46a83dd2f76bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "37792d29bd44d37794b3d3046c61f5d7f811d82df979f0d6b9764eb27a5b5edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f169d521d4580ae21aee535cc2f509e6972f216a4a7c02871ecd4905c215dd"
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
    system bin"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath"Pulumi.yaml", :exist?, "Project was not created"
  end
end