class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.133.0",
      revision: "1c54d114edab147f015b02dc8da746d87bd12415"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5609135e4bf2fbbd9365ae6712b014a9ad32964f224c47b0978a152f985f68e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9ce84791776da864d9aae5221d8cddf4ba0ad400eddbc966c86dff326853d9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "779f86bf42c1d53de1fe2b5e64c963f42d37955ea9ad42ac536862cb5e8e2bb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7812f141cc8f863b7ec6eb45c0690a93bb3eecb9d6d1f6df3a734e8ef874f054"
    sha256 cellar: :any_skip_relocation, ventura:       "989e8651f25a200459bcf29826b497089bafa7060511ddb68593bd535a51afe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fe858d1577398c97404c36f8b6547da00e60a8dc5a3a1c887c87a0492fd274a"
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