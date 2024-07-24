class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.126.0",
      revision: "4516fbce89af1188bbc2f049d976e3d6b81a2666"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e434ccc1e03044006bb04fa6c20a6bb0287185c103bdcb32a6bf06018be84f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3667a8e6a68ba70d852a89dae1ddd7ab9f6a6d31df01d5eda29262c655332d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8a7802d6897425ed54e66a960f0134ab96e2aa833d2a967d1d7edae495773d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b0fac1650561465f0b446f82a1a4cac761ddeb7ae19be8fe4ab05ed6efcf3b6"
    sha256 cellar: :any_skip_relocation, ventura:        "3400c1903b62e1921a616e1bc8b2f4fd471b9f4965bca8b7bc112f57e800de2a"
    sha256 cellar: :any_skip_relocation, monterey:       "edb660cf9157d84b6a75153747dbb86b6bc53a6884f4a10cbe93b36a6e3b0631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62f736542d15611ed0d2b6e668a23b34593015fe3f585fb2ff8ff49033e9156a"
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