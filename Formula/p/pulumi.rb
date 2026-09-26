class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.265.0",
      revision: "fb9dca8b2cb18da29ba6f9e2690adef3b9b423f1"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8afc275d99a43fa4f1e8f61aff25b3bad26ab3fef22e40306f599766962f322d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66716b8d5af3eb64a5178850793368e362bf696ac5d4d897038208b1440b8539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "039a466e298a997c2f6776aa189320ca47cb81165ab805f5972d3740fb5a40f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a56a2478e2eb0cb23c07357312a6c45f196fbb4ece61fb5ad41d6985dc182048"
    sha256 cellar: :any,                 x86_64_linux:      "5aae22eb813ecd3a61a8585adc67ccecaeab665515ebaeade5956f53ff1c1199"
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