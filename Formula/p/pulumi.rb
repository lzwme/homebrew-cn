class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.238.0",
      revision: "71ddfb54af45d028583ec147ca80b266efc3315e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c074df2e4a8cac265728b2f6a156a8e5f0c9bf47a85eadac8311305be83de822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b6a0983b83db4962528b2e584467b98715d012fcc6028c2a2ed5525815b55a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a9337fb4d065c4f9f0ded9c5fbf5926101c863663bd15ad07eb48dbae62f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "375832711d9afa8f1982b54f4511547df4b1dbadc4398cb3117d7fa699a0f65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a0d3cc808adf2ff06f79af7df392bf97ebb53ef07d77999741b4eb98d597a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c692cc9faee0a4b43300b8556bd7c9a91301fee99bae135c7b5f192eb0364d86"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end

    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin/"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_HOME"] = testpath
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes")
  end
end