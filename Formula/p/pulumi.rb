class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.268.0",
      revision: "128d3f2ec94e147915a6a928fdf7449d561d560e"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7125f6ae23734299945b56cf16431ff050480a75b88a456cf0e2ff21b7d1f0cb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52945700bee5758a472b949206b8def7a4f1a459d7065abe1689bbb08cee37dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b277b4672b47cb9d0576cf99a4480849d5ff3428f8daac5aa47e1541e5b53ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63fd18321473fe0a668ab477237aadb91e1bb19f6265c9f0e524b39cb81378ba"
    sha256 cellar: :any,                 x86_64_linux:      "a22fb0d1a053b3c3a658f448c095c818e01f3d7016a5baf7614fd77cee937ee1"
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

    (testpath/"template/Pulumi.yaml").write <<~YAML
      name: ${PROJECT}
      description: ${DESCRIPTION}
      runtime: nodejs
      template:
        description: minimal test template
    YAML
    (testpath/"template/index.ts").write "console.log(\"hi\");\n"

    assert_match "Your new project is ready to go!",
                 shell_output("#{bin}/pulumi new #{testpath}/template --generate-only --force --yes")
    assert_path_exists testpath/"index.ts"
  end
end