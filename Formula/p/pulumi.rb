class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.123.0",
      revision: "21a7b501b49de99b74eb2937ea932a89b9e55a79"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07a810def3f00db204a72d221d09132fd9f8e0251867cfd91f2e649f1c3adf01"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f90b6552021fb1984c15c90a258bbd2b6f230da80d197548262c5a16466f135"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6ecc00ca0e3ff7819b37898061668ed5840e2cd41f8dd2ec1f7158f2aa33e62"
    sha256 cellar: :any_skip_relocation, sonoma:         "417fc42aaafbb945562ad1956a9d30841711b58e4550ff9e55b2dafb57b0089c"
    sha256 cellar: :any_skip_relocation, ventura:        "3bdbed7775f09b08d8e1b15dd020dd6f1b6b3c6a346ae00d269369459f38bd43"
    sha256 cellar: :any_skip_relocation, monterey:       "e585d7c659fb0c1e5f1f87cab6e292758d0d1690bc682ede9640e9294a94e612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f79c641469221efd70f409f2770ec923a098d3fa8dbe70f83b914f107932e845"
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