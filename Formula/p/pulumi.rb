class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.264.0",
      revision: "32519795baa2b65136588cb9342883e64fbe3db6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b523e8e91fd1b2d4f4bf13453202a8586010dc4ad80476b32dc5d781afdd6d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd41cec81a6382a5a0be306ca40752f3811f21bc6a807f748f9e01ce8c34307d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1193a94a98e79334d8747b19782f5634ab26c6905ca1da039292f9ca5eaf3a93"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2696c5e28bf44916df1422adf8eabd07b1ae7bcef4632d48380075608a03d067"
    sha256 cellar: :any,                 x86_64_linux:      "5d9c92a0de978a2fec75d930764ca54b8720267c34c16a7ce247bc945e5ea775"
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