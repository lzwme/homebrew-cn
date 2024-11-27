class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.142.0",
      revision: "1837a707182a1a9e2f9ed4898895e5bc562dbaa4"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7bd521fc6c3506ae34d684aecc68fa59d30a309863a398f7a9d62cd2739ba9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e040c1433f9d7fd4e2026b576bb6567d76ffb87d55242efc3fe25ab83f42c043"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db9bdedf0010943776dd0fa16dfa3b7f9ef9e196d5d5738b2d8177ac5f748f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "04311e2aceb5c57a1595563006ba7ea0ab3f808d8d87573b548115305146a4de"
    sha256 cellar: :any_skip_relocation, ventura:       "a8b462e86a40abdbbcc9f17575b43d29862a01d72e82fabd49134dc6e63aaceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f99b1ca8e55e1a8daf0e3e4c6ce2f0c8b98c1b71542410a0b50b733b66aa6d0"
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