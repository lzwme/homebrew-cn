class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.169.0",
      revision: "a4bdc94d01aabb48287140823337d0115ee5790b"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "259f16c6ef8312e984189c2e55b212170439749d02ec55f427da90188a27f440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ac56a560d51452196938d459d03a6ad99f6d981107356e6db15a76371fcdf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f53a3ece913d97ff809c12a7f0399f0fd9085b344abc89df8a7fa62745806b49"
    sha256 cellar: :any_skip_relocation, sonoma:        "786d36c6680d785b8b2b2e9a244b8460169387871d62dc4e097faafe91952372"
    sha256 cellar: :any_skip_relocation, ventura:       "9cc760e6a2a028d85f2b616b3fe0c7348ce8a277eebded84d9f069fb47695cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bddfcb11658e8a3d8fc06ffb24ea3304e41bea451c57948937b984697e0baa1"
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
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    assert_match "invalid access token",
                 shell_output(bin"pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end