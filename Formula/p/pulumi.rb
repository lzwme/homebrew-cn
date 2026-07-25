class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.254.0",
      revision: "656b95485a444cc41748b4c3b3e803126bf4ce8f"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c167ea888b8febd8ab0f12cff2c10f434ec596a2c50cbb51c6f62d9353da28da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74ee9dc5dd52ed773ff8f870c50e57a36effcafc268849dfe7467deacb2918b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f11e6dd4d9a841607fe695a189f315360f77fa4aae6244fbd50d681661c6f64d"
    sha256 cellar: :any_skip_relocation, sonoma:        "923726e342da314d80722760ae5e6d9c7527ee661fdb5186aaa629def30c918c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b26ec669b397d741932cf80f38ae9c65a82aba839912cfbac64d6ad18407c58"
    sha256 cellar: :any,                 x86_64_linux:  "1c95d31bc46b586d434a4052bf9b69893465058be906c74c9870db43f822fe59"
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