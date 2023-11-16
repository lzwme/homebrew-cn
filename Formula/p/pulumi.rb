class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.94.0",
      revision: "3b1150bcdc56e778d5056059424e0a9fa6a8ca0e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0bbaab8557e4c2abc04923c69ba9db09724146eb2bb6d1a5ae2357bf1a113f58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "413518d8af5c27c79943aef2404330594e12769cd0d04a07d46ca0464af240b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a42de667a3d25204bc93e2a6ebc6b827d7d7ab35fd0c740e91ce567a68b23512"
    sha256 cellar: :any_skip_relocation, sonoma:         "46d2fe81c9eab81ae21d4e8a7de0a57020f0ca1203688c6c0e523a6877c6ac9f"
    sha256 cellar: :any_skip_relocation, ventura:        "c1b9a2db2af401d53b5ad2b8c57b31eba82bbd9d5a79d914c23205d7c63645be"
    sha256 cellar: :any_skip_relocation, monterey:       "28faf5c8fa410351ab6e73b970cd93e943a5163f19fb2ebd2b39ca8ed2cdf411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d884c88a693e77adae6e8ed191cc46c4748c50fb0e5c4f2675ad7171341721"
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