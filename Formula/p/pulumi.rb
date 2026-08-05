class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.256.0",
      revision: "dc5427b5a2de31ff3137977399ef6c2f01407486"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca2b3a21a337a7f69343e4a1bf0d03929e8360458490a719256a44de3fcc5e38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4226be18cd849c27233b871158dce490cd40a6e6e1f3db1ab969362fe314e57f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ded9c8984259d74f676c9313c4afd16b5f317b0d6bb9326870d434cd86d2146b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9b01d3a404b12d859ebfd781372dd7a2c8ed2bd59d5272f0b54838c069b1169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b68bb2eeca5855014f1864290688718650ad4dd2d040f2e342efd5b6eea71ba3"
    sha256 cellar: :any,                 x86_64_linux:  "cce087498be3c32db5e7059f9a031dd7e73592df80a1f7d68e4992c41e7209b1"
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