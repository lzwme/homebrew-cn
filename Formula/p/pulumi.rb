class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.121.0",
      revision: "79e814fe0f2137ade87ee5af384e6cb71e4aa6ff"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3959896abac8d1715799e024ed8ac6883f32f3b49b7444442752d11a7133affa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84d86bf62d9977c9ef86074230f68744453ed9991f412f93f85890f6ce2d4e8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05b87bb6e2137c9d26cf5afe7d76161f94b10a436dfdb090b653700941d11794"
    sha256 cellar: :any_skip_relocation, sonoma:         "01f76ce7a9bfc2b42bd9b90b66b1cdc2615446fa9eee852368ae5cf19deceb7a"
    sha256 cellar: :any_skip_relocation, ventura:        "ddab9bbde9624dd4d966d0660a8eb6da8cf9c199ff842dddc4c2334dd84003e0"
    sha256 cellar: :any_skip_relocation, monterey:       "4af725b46574b095838a7094fd89e12546cdd3ff1d4e493bfd86ec94ed1f0681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc143861f8087acf9bbbf4a006384ff1c76686c7de462b7bdf8535908a102903"
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