class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.113.3",
      revision: "75340dd94203da02e44ca5f8beb55d9063d302ef"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a070483cb61e4747f3b4b4c99ffb8720c373c2c2acd0dc42b7ee9873a2ea9d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "411c3c9f18aaf60baa92a1dd56b4d73e187bb35a9dda8df7a9a592fedec40ed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af2d112124311d5ca977def8646df92c58cd5b0c1ab296de93884726045f7ccd"
    sha256 cellar: :any_skip_relocation, sonoma:         "2993c379483b86713aa5bbaf8d96ecc0f9a5bdfc6005542671013d7479be2bf1"
    sha256 cellar: :any_skip_relocation, ventura:        "612cf509744c2ae66ca214b4c50215dbdaf0c006b48c914e66459e4e27d367a7"
    sha256 cellar: :any_skip_relocation, monterey:       "d94c5c74b0fe4f7baa9148cef4178dcfa7ed6f11be61e57c4d0a563d63f2216c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "981e690d4d8546df6fccc1c379d42c4ddb04b45e390877a2151d828047c1fe28"
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