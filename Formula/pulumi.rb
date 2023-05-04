class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.66.0",
      revision: "175a01585cca3910908e05a25b06c97e297a8c36"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46aa85e1e649da8c14d629a6140bc6a0a1500903c00cae14c4e164c949f0caf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70a7b2b9986666054196a4f3938c27aeb5a7c536706734cc84a70a5b19ddb05b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b20b796525ea279e4ebb774304fe797a8bd45e11731c81b739ec9dc115979272"
    sha256 cellar: :any_skip_relocation, ventura:        "c1f530e1020f86f6445de421e9f3dbbe0f4321020e936434067b35d0017656e4"
    sha256 cellar: :any_skip_relocation, monterey:       "673394f4fa3d23d0c6774a96228f9e02001ca4da579503cbae85983deb2ef838"
    sha256 cellar: :any_skip_relocation, big_sur:        "32ca3b665dcf7c7503df068a214dcae016fad82f6e4f252b63b619d092c91052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16c102501e893242c603119b2e99aa8bcbc6f4c76b8904608a717c00c9038883"
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
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end