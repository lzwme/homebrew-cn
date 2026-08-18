class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.258.0",
      revision: "dd623623bc63a594228811230dd22a776fd3fedf"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ecf01cbff91568e05422db4802d77acca6aa30f0d7816e78b4299494aa114aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a82ae916425ef12d5379f11700a37ea0d237fc74b66259920bba24512677f5f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b2abba178b1822965c6f8733055e092154bea3a85e1520b3b96c2bbf62230d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f022fc9bef74c4c9e42145e431d8485c223dcb59e9f01f3a05abf58d1a52d904"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78de9fff8fae66cbbf82404d3cc035b5d1469c9e2b1a871d0488a2e19105f364"
    sha256 cellar: :any,                 x86_64_linux:  "b16eab941be30038ab733360348000903452df4ef702e8ac50ea8aa73a65a4e7"
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