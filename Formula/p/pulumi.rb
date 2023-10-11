class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.88.0",
      revision: "4d3b82cb9ff6585a096c8c6d86a0e88a7bc5be08"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cca63afd9edb474a3ede40cab432ed6ed7f5131f0b0fb4ee5adb4b3a62598f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "678ff2d5539fc91d3b3a698c9cecff9b945341f7693d1057151e662da33b85f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e32951be1dd7c02e7ec4bd30cb498f107545c24edaf6a1f5a3a5b6f530e2addc"
    sha256 cellar: :any_skip_relocation, sonoma:         "a53acfa94226c77c282e82ed599b655f9b82b6cfa7b7108e9431868c7d06523d"
    sha256 cellar: :any_skip_relocation, ventura:        "6aad6e22b046ad8350e92f2401a0762a0c7e37d78e261bd6a8661277d07449ff"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c56fd706a8317b5b488ed0d18599d3d1c4341d7c1ab74f0550287f70b79b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4714ba16968fc5db32a9fe97de4793e181b27fc44b573c0bce8674658368e9"
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