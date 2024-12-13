class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.143.0",
      revision: "aec19d44f93c770eee0f1eda7ec4b148b53664a5"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cd5954e864b1df41099c24955984a6cffc3f8a1b8d97ac4b34f74aefaf3aebe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc00debebc52843f055f330dc5b70e0eb3e50d734e1ef5b75622327589c532f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b60d36cacee6c418772308e8a60466b6396ec00182bf981542fe4d9a0aaa2775"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d69d7b32903e9eee28c154dfae200cbd543a63e367900ca65c06f271df221c3"
    sha256 cellar: :any_skip_relocation, ventura:       "91d33ea84a3e2a0196d5dcfdcb6213940a84363d5f87b08d51b8e46a1a16664a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7faa4a79f4c9cad1483ecb7a2b25ce63dae351afa04dee8daa016a77377b7d96"
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