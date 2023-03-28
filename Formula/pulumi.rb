class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.60.0",
      revision: "7fdcd6792d2ed653e7ea2498b3615792a59a91a3"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "520bd6a07631d7df2f526f43bde857bb1cbdaf82bde3d91601efdd357c3b20f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4e22e001b934e5566dae84c6f50ff2a983fbba8bc1c5ba59d13553ce585f4ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b82205c18d73553e2ace40e0164f5540af20a77b974eb9fc985c3b267a3015f7"
    sha256 cellar: :any_skip_relocation, ventura:        "8bb00fc04f5b77a73e00d9e9898a9a052d8f51f670a6ea5a798cb4ee2406ffa0"
    sha256 cellar: :any_skip_relocation, monterey:       "3e73672433cb60e9fe084dee264cde658cac6d4b3d0c230131683dd136ccaca2"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d4294a62f0c153c98ceb68bd991e346dcd8b3ceba49bab40c7bf4ed9439b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1640160fab652e4f77afbcedb8c42880eca5b0283d7b113116272e770d70eb57"
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