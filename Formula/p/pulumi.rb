class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.124.0",
      revision: "100470d2e72f0c6d16d3cbba661e9509daf43bb8"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fc6388377ec35efc0649e32046f57b76c2f4f052d748fbe05c9ba9cac0454f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97b800ab11acaff98c7c33022dc1e238dc687080e615441ea32c7fa692a2534c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fc17370b6b131ef7fcccce7e4032a3f3f31d6d5a2c5f56243b636124d46d99a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fda269230a6fc5ba26a1308d115088c84ce3354220aaa6c45799f9b1bdd92abb"
    sha256 cellar: :any_skip_relocation, ventura:        "89c6676da889444059df5b6113eb91f04d2d3cdcf51965482c2db543f0e81d08"
    sha256 cellar: :any_skip_relocation, monterey:       "b83c738c8b17829daf39f51d9cbffa87cc3776403f02a87ad56a08bde770f873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16e5073264232f7828f624e6fc4b3425f356f26a5d2a3a67f1a794a10630e7f4"
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