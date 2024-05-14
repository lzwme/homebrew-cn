class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.116.0",
      revision: "1ea602d7fe4c5a2b8ecdbfb76a273c657ccccc00"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "800cec0fc9d164274ad57c40dfa3d3ae68d2532de721bee9f52a3d706832a01c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "060214fb1e1e8c0f0159974fa3b210d261dd28e1428c91cacb149ce721b9173c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f06d008046b41b6ba31c5662f9be8127e675d57f2801abfdd1c3155186c85e47"
    sha256 cellar: :any_skip_relocation, sonoma:         "4a7cf7c278b64012ac47ae78d0db17b39b7335a4ee5b76685f0fc0d21ffd7612"
    sha256 cellar: :any_skip_relocation, ventura:        "be45c90cca4844ec5b9ac7977213c709a3cc59366213dcca74a94d82c0431914"
    sha256 cellar: :any_skip_relocation, monterey:       "269e8135ab2066751ead7e9cdce8ef03b3f2aaef0417e6fc0a0645fdc62bdc2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a43be58474412f6d813ad513f686cc1684517e6ad5b2b0ac00555ce146bedc5"
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