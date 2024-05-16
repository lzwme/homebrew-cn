class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.116.1",
      revision: "76edb80dc18ae9f257159c96fe1eed733c5e4db3"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23d898db1edc43beb68444c46da8beada5fd9acca913d065efae62cdbd6a0320"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e72603ba127c2ca6c50cdb59d7dbbf21d6d47fa09348bd877657606183196d51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b83c344c08f12e2fe7d1af97cfc0afa687885540d09cd4444645a449b34ec66"
    sha256 cellar: :any_skip_relocation, sonoma:         "519fbc8702350024fb51c6f62e7fefb66cbcb54c7d2b820396f4e2daedbdcf07"
    sha256 cellar: :any_skip_relocation, ventura:        "bbcb99507f6b8ec8a503e7fa378789ceb5459fe02f3d83d80f98e7a8404b74a9"
    sha256 cellar: :any_skip_relocation, monterey:       "4aa9948ee9c270b34dd9e091d27caeb82277522a52c2f1384120b132fbf9ea00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea7c102ac2aa876470aba819a37d158c1630cc38d27e6ffda5efbefd6e2ddf9"
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