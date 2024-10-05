class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.135.1",
      revision: "4e90d01cbdf510dafd11d4933dd907c53f3b3196"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "586267ab0249fe12638ff99d0a95eb5d1cdbb244dfa5664dc7c9d26d72662438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef7ef5882b0792c30f11ecfc9cd5d7b99d1904d24ae35be22facd94f7e86ba2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7543162b3390cceaa9c36547d1c39398fcbe2fb2c41db45982e73de38cceb963"
    sha256 cellar: :any_skip_relocation, sonoma:        "be09c3253fcbe3d0727a05b8cb260174907447fedab5033f7fdd45fc0449aba8"
    sha256 cellar: :any_skip_relocation, ventura:       "cce89aa2197db2c2e435e29362d1d5504a44d8711aaf2804fb3a3ed870b6a6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33ae03a4b7554f625cde66fad0a15c3308b483205b4e5bbb26a30b26b9f8530c"
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