class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.266.0",
      revision: "b2d1f46606ae2b1b082db5ec3a9bb65f45ecf229"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9cb12c41789d21fe5272289fb62729d5494fed575428f85b8a15b878d439397b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "705d551aef01f111bb46db560ed98fcc3f29674a1e4032a945418c5188c12b20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ba192593be81e56052bbf191a991effd7f1ce11d5107c42ed29fa846490b049"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88aad7fd17278e0044a914a94117038b2f7a574c7d1371aa5ac784184b7b53ca"
    sha256 cellar: :any,                 x86_64_linux:      "b3f75816cdf9bda6e258acb9ab068473ae3ad20abec83d574c0f274fcb7e0f29"
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