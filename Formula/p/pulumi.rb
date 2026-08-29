class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.260.0",
      revision: "fe974d4f306962ad3a4aa273be83b98d6b2ff1cc"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8df04106afd6530d9997519321dee020c43c7b8f5a293bf943b6b3c8e78e2bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4bee65e646f8a9d78c27125d2da0367db192b2407fa80b84ac9acc9837f17c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0019514f3637d4d13aabaaa9d315fd0007f9ac33b6241cdea4b6db9e3b7a4bdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbb9a681e79b36837c797373c4442e66c98cdf8fe1b5d4e8ef6b0362c596040b"
    sha256 cellar: :any,                 x86_64_linux:  "e07a9aeff521293aae67244404556237b2e2ea4edbecd021ac5521f294d0c062"
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