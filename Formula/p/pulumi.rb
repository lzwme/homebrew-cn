class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.257.0",
      revision: "5a7ae5c7b7970a44cc1f9eeba314cbdf11bc03a5"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a549bb4afc8603e1772133df0887da83626415995fb1cb6c5e9c07c978f9af85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "222de320833bd3eb3a644ca48fc5e6c679402b3055525de3c07adb2a19898af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f58de39c326b18219b6c39e28311917709907ad7fe6ee04f3d01c596e824a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b13c95a7a30e379cefc8ca0710a8a960cb728b220683af193a68585e95eca1c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d64f77bc9d36bd7d7ef6146d1db97eb437fced14ad6231cd6a29c4c17456912"
    sha256 cellar: :any,                 x86_64_linux:  "98ad8525fd5920a1f9d74d0fc307d36e867b44b34a10c70a8a76233116b7c735"
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