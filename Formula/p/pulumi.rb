class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.128.0",
      revision: "c428a91a4c3c9d6b567e04fd7a7048db24683883"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7695c1c375e243f53c854e57dd5c940fc227e97b7cdf64bf1474c41da8d2156"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af01ffda19adcf9f3d06f205c68bf18197dea33374fe04eb1e753dabdffa422"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a1b343ba73eb208e18f0f96b4558f13e0b9b584ee5de233dd73eda1807cdd6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "98dbc8cf5244e3934651f159c80a3ed60649674ecefd7de6c48a3a563d31ff02"
    sha256 cellar: :any_skip_relocation, ventura:        "3740184fa0746d44e898c8119c11fbd65129cdce26f5898f66fe4cf3efd1b81c"
    sha256 cellar: :any_skip_relocation, monterey:       "807ddecdf69e50daa768441c625acde3f736fdde39a256407d8976a98c8a9b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ac857556fe0771096e3485302a836b3200a3d25a96894b5b3a6b2339bdb9c7"
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