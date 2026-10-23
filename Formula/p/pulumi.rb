class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.272.0",
      revision: "8a99ec577bc354b20c777246ae04815462dc9435"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c76ae92e9b29aa7e658145cae0180474ca7e071acec44e4be02e35d9933090bf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1070099ca9823824d9c426f031425820e0c3caea13d67715f1ca3c7bf46a921"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9de03af23c7c36a71137f76ab7e100b6405a0a2f750cc2bf8b96bc9fe7c79661"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63b58437ef4a9b436ca1d9df51d1e134e8cfbe639780c060d1dfbf52434bbf56"
    sha256 cellar: :any,                 x86_64_linux:      "c338b2dd4dfb3bb2ca47955cf21772a582cc90f205f88599f19a52fc07934eea"
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