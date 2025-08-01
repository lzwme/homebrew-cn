class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.187.0",
      revision: "ba984452ea927e63cc995be2bfe1a4192adcc608"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7568ae0dd47a6fd291ba5cdd5b418927109b9fc0393569a69e2a65b165b00f46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "890cf1979120a6d9d0badb61631ccc4f53ef906060c1ae5f4dc87f37ddf6ac0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "261c01f4bf09f1ee6b8017043f4ef6dd537d20d73d06b43ef4389b72a5c35225"
    sha256 cellar: :any_skip_relocation, sonoma:        "97e388fc9bbc8fec4f57cc8d6e558fa742f04439379c03e977b2312f1b57dce2"
    sha256 cellar: :any_skip_relocation, ventura:       "7cb33a6609bc664d7c5b68df978ec85802d8def782ec853800bfd7c30885f41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18da549751c52d1146a6b786a01ef1e9f5cdb0ec18dfdcdfb080a17a8d8e3d5a"
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
    assert_match "invalid access token",
                 shell_output("#{bin}/pulumi new aws-typescript --generate-only --force --yes 2>&1", 255)
  end
end