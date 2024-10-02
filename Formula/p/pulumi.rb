class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.135.0",
      revision: "98181d7e71119c0bd16d5a037f7367452d40e852"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1da8293df888910be95515bf55c7ca1ec396d91f0b8ed75b31aee1e1c759ec30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c59bcd6973e91d2da7d2628af94dc0a346196110274a0e25e1bf2ab1acaf0f3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40b725eb53a35743f264519ec71168b43cfa2e1626b41e48ca0a01fe3761f52a"
    sha256 cellar: :any_skip_relocation, sonoma:        "57a8d81dee1ab474cdee22b4c16888ac3bf48b982ae050bc143751ddcb423943"
    sha256 cellar: :any_skip_relocation, ventura:       "742d600655a4c94c4a056762b5f1a1d6399ed73bf8e654907ab34b67eb231cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3f0d432d5463dfa871408f183d39911b63ef4c9224b0c9c6e4c2f4e807be9a1"
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