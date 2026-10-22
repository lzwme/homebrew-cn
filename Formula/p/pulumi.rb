class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.271.0",
      revision: "082147399d27dc2d19918a61a0508ff2146394ed"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1322dc6ce1ade8bff311868d6722a13495429e8b21d0ad1f0673254d5717ccc4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5406c337060601ceaccbc6954352c156e02b184847756685cf51cdc73ab09e55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "07ee96d9fc0b17c850607eb1fca71e8b85cd79dc7cca526373f0504dc1fc55f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "287574fc08523da48d25c51f5a539f368ddac1c85a3dbf826d7c462c7cc48d53"
    sha256 cellar: :any,                 x86_64_linux:      "9e8bdc260350e5228e91c19f11d51c6196873277b8b28a2155d4005d233e5077"
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