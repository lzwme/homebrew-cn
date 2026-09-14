class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.262.0",
      revision: "9c1b6fffb6d2c3e2e2ddf3e7985aa5ebe95e8b89"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bc5b8ebae00b208ed661d869a50df6bd32c53e702ac853056fe2676ee512bb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd3aa31285973f9b72944b8ebbe3b20e3d84ce544f9d3565f664f8c180237d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dac2e618193eb0701ee526bdf6f941368150704a3581e7e0da272ed6670247be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "918a04a202d656b7b96c3ec08fec7279c1f05c62a0c343a52b45fdda2d2aa5c6"
    sha256 cellar: :any,                 x86_64_linux:      "bb6a6a1e91b29fe85957f6e9c246e15ce652a45118734f8ec97a2730b1e8d316"
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