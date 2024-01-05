class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.100.0",
      revision: "956c3aa2a120110259a5fabf87a45f5232a8da4c"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "015b3425be19113e99e465bd477abd4a839c5f0a8fb58b44275cebc3b81b3c6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d168e752e7ad55d303caceebe4677feca2092cc865df2ed53c1a665e7e8bfc7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "632b560c8df8f6c3cd7fb8ffffc444f8fa50c4d73754917f1ff941cf867e707a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bb04d545411168592dd9a5c1b718633323e4c5d5eef3f565da3050e5481ca3a"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5561bc596b178673d6fb75485c5bc6b2f9338fcff25d873838b0bb23d594dd"
    sha256 cellar: :any_skip_relocation, monterey:       "a114341e9e3ab508f0995d2406e7b288fc624cb73126e01946ec20855787a6f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81f66fff9e15204fd45a6ec73ea04a10cde588ffd83a5d9cdf627739d98986ec"
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