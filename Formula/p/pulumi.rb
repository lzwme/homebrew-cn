class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.247.0",
      revision: "21bf19ba40dba5dce0f565e8c614b5d8aa4dbb17"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1ab7c62deb843be67afab50888d8bb83f6289403aee0739e3d47c4d362bda80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ded556165b96eae4f4fd49857a1c71adece79a9fa9b414f8d5bd1742a3deb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3aef37bfa225796209d97ed3c73b8c82817fceae8cf51fe944cbeed1c5848a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a1f0fd0cd1b9793a81fac15d97f7be9086d57c8b52bab332bc4963412be3c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b00f51a30050fca51184940f90710cfd6d94310a310278a1067fa811300ffd9e"
    sha256 cellar: :any,                 x86_64_linux:  "52d6ba0b6b6ae59ae8832387685bdd36253619edd96cf410778fd0aac609754d"
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