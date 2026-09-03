class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://www.pulumi.com/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.261.0",
      revision: "de0633d6c611507e17ddc5b6371640463b128522"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b8658e8d8bc304445acaba689ff21156aa03819c6565fa8e4b1a5e48204bcfa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68517171018042a4492cf346173db638074a7f9408a8496110d5915152048524"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b41efe8a3ebfbacadad1a2d95e5e12ce315882055ec08780d627375a1de33ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62e61ab0b14be00095cf009b24f1c942b8a0dcc6c5de4fbc0032017ab8d4bed9"
    sha256 cellar: :any,                 x86_64_linux:  "b8ebb099cea84ec739644984c4491d9bc72913a1468db6c8a5ff13d20431dc28"
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