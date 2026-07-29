class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.255.0",
      revision: "7a0dceacbe8f6a42ca12d5da16c271e773cd9166"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b35e42c6c89f12f56fd9269b20fb75ede29b4aa48103b0cef3d02f92b8c8ee6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "319e2cf808306342fd82f5cb329722d9b686e2a38ea75b7dc4c14c1bc0789c0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0932237b3a2db532cbe58a9d4da28ff37e792d8749cbb4db5dc4b1071103e528"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fbef9a4794bde7108b25768c0b1eab811fdb4c50c77d528c049202841de9a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d38de558f18a551fd55b599974b1b298ff9c70e603ac540045935f8bf4ce147"
    sha256 cellar: :any,                 x86_64_linux:  "837664d40ec3186acc8e128e23774a5b4893754e9304591a3432fd1a52763174"
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