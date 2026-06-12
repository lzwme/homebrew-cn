class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.246.0",
      revision: "1ff8e765645c786ecf1ceb0e8eef158383766e68"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be8785bfdb0ecc188f9e4e14fff5836051a19fd99e7e3ba06d7a42d4a9abecff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7d3efb46e41b172c134aca84fef66d8496c4b6663c508cd54a5b6881261a969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0b8623b9a8a74fc7c533543d54434149d939ab6f031f77854d4a875dea9fb28"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb31d6721e59ec16a41fe6ced1627e5d8cc5b9169d973e24b7a82c1726a82119"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71fd76ca6b6302f2b1c2e22b676dadb9fd0aa537cae8756d258fd5807ea85e1c"
    sha256 cellar: :any,                 x86_64_linux:  "6ab7c5d4f4981f043c45a2ef5efb5613da8398903ba7e7569c5569f765b2e894"
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