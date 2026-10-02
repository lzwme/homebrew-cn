class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.267.0",
      revision: "eaf158ce39c24a5905bab4de822c6afcfc0d3d5b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "34815664e19c7a935b7eca2b61afde3ca4640d520259f763cdf637e68f5fdd2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea804ec722f3586a769b29401625a71c49aa1acf9841ebca04ae203bb492c2da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "31db555098c31157af5332721bdc616e09ad9a053e167e77b6e815d93b050a61"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f7fb6b439073795937bb026700f22719e9409bff677f47af1be4eded74dbc97f"
    sha256 cellar: :any,                 x86_64_linux:      "5824448148b5d713f1284c0c9e86f4d25035a058c2d91fd5a5a6f7c516d6d642"
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